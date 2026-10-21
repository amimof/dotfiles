# Generic dotfiles linker for NixOS (no home-manager).
#
# Usage in flake.nix of the dotfiles repo:
#   nixosModules.default = import ./nix/linker.nix self;
#
# Links are created with systemd user tmpfiles (`L+`), so they are
# (re)applied when the user's systemd instance starts.
self: { config, lib, ... }:

let
  cfg = config.dotfiles;

  # A link is either a plain string (source path relative to repo root)
  # or an attrset { source = "..."; mutable = true/false; }.
  linkType = lib.types.either lib.types.str (lib.types.submodule {
    options = {
      source = lib.mkOption {
        type = lib.types.str;
        description = "Path relative to the dotfiles repo root.";
      };
      mutable = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Override `dotfiles.mutable` for this link.
          `null` means use the global setting.
        '';
      };
    };
  });

  # Turn every entry into { target, source, mutable } with mutable resolved.
  normalize = target: value:
    let
      l = if builtins.isString value
          then { source = value; mutable = null; }
          else value;
    in {
      inherit target;
      inherit (l) source;
      mutable = if l.mutable == null then cfg.mutable else l.mutable;
    };

  links = lib.mapAttrsToList normalize cfg.links;

  # Mutable: plain string pointing at the live checkout (not copied to the store).
  # Immutable: path inside the flake's store copy.
  srcFor = l:
    if l.mutable
    then "${cfg.checkoutPath}/${l.source}"
    else "${self}/${l.source}";

  # Targets that sit inside another linked target (e.g. both
  # ".config/niri" and ".config/niri/config.kdl") would write through
  # the outer symlink, so we reject them.
  targets = map (l: l.target) links;
  nested = lib.filter
    (t: lib.any (o: o != t && lib.hasPrefix "${o}/" t) targets)
    targets;
in
{
  options.dotfiles = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "User whose home directory the dotfiles are linked into.";
    };

    mutable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Default for all links: if true, link to the local checkout at
        `dotfiles.checkoutPath` instead of the Nix store.
      '';
    };

    checkoutPath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${cfg.user}/dotfiles";
      description = "Absolute path of the local dotfiles checkout (used by mutable links).";
    };

    links = lib.mkOption {
      type = lib.types.attrsOf linkType;
      default = { };
      example = lib.literalExpression ''
        {
          ".zshrc" = "zsh/.zshrc";
          ".config/nvim" = { source = "nvim"; mutable = true; };
        }
      '';
      description = ''
        Attribute name: target path relative to $HOME.
        Value: source path relative to the repo root, or
        `{ source; mutable; }` to override mutability per link.
      '';
    };
  };

  config = lib.mkIf (cfg.links != { }) {
    assertions =
      [
        {
          assertion = config.users.users ? ${cfg.user};
          message = "dotfiles.user '${cfg.user}' is not defined in users.users";
        }
        {
          assertion = lib.hasPrefix "/" cfg.checkoutPath;
          message = "dotfiles.checkoutPath must be an absolute path, got '${cfg.checkoutPath}'";
        }
        {
          assertion = nested == [ ];
          message = "dotfiles: these targets are inside another linked target: ${lib.concatStringsSep ", " nested}";
        }
      ]
      ++ map (l: {
        assertion = !(lib.hasPrefix "/" l.target || lib.hasPrefix "~" l.target);
        message = "dotfiles: target '${l.target}' must be relative to $HOME (no leading / or ~)";
      }) links
      ++ map (l: {
        # Only checkable for store links; mutable ones live outside the build.
        assertion = l.mutable || builtins.pathExists "${self}/${l.source}";
        message = "dotfiles: '${l.source}' (for ~/${l.target}) does not exist in the dotfiles repo";
      }) links;

    systemd.user.tmpfiles.users.${cfg.user}.rules =
      map (l: "L+ %h/${l.target} - - - - ${srcFor l}") links;
  };
}
