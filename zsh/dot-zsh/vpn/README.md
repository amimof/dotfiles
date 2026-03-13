# vpn

Wrapper around `openconnect` with support for named profiles.

## Usage

```
vpn connect [profile]   Connect using a profile
vpn disconnect          Disconnect
vpn reconnect           Reconnect
vpn status              Show tunnel status
vpn list                List available profiles
vpn reload              Reload vpn.sh into the current shell
vpn add-host [vpn] [host...]
```

## Profiles

Profiles live alongside `vpn.sh` as `vpn.<name>.sh`. Each profile sets:

```zsh
REMOTE="vpn.example.com"
VPN_USER="username"

# Optional
VPN_PROTOCOL="fortinet"   # omit to auto-detect
VPN_PASSWORD=$(op item get <id> --fields password --reveal)

tunnel_nets=(
  "10.0.0.0/8"
  "host.example.com"
)
```

Leave `tunnel_nets` empty to route all traffic through the tunnel.

Any variable defined here overrides the global defaults in `vpn.sh`.

## Dependencies

- [`openconnect`](https://www.infradead.org/openconnect/)
- [`vpn-slice`](https://github.com/dlenski/vpn-slice)
