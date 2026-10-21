self: { config, lib, ... }:

let
  cfg = config.dotfiles;
	srcFor = rel:
	  if cfg.mutable
		then "${cfg.checkoutPath}/${rel}"
		else "${self}${rel}";
in
{
	options.dotfiles = {
		user = lib.mkOption {
			type = lib.types.str;
			description = "User whose home the dotfiles are linked into.";
		};

		mutable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Link to a local checkout instead of the Nix store";
		};

		checkoutPath = lib.mkOption {
      type = lib.types.str;
			default = "/home/${cfg.user}/dotfiles";
		};

		links = lib.mkOption {
			type = lib.types.attrsOf lib.types.str;
			default = {};
			example = { ".config/nvim" = "nvim"; };
			description = "Target (relative to $HOME) -> source (relative to repo root).";
		};
	};

	config = lib.mkIf (cfg.link != { }) {
    assertions = lib.mapAttrsToList (target: rel: {
			assertion = cfg.mutable || builtins.pathExists "${self}/${rel}";
      message = "dotfiles: '${rel}' (for ~/${target}) does not exist in the repo";
		}) cfg.links;
	};
}
