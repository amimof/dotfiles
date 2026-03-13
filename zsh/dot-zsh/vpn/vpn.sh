#!/usr/bin/env zsh

# ############# #
# CONFIGURATION #
# ############# #

# User agent
VPN_USERAGENT="AnyConnect"

# Protocol 
VPN_PROTOCOL="anyconnect"

# Path to the pid file
# PIDFILE=/var/run/openconnect.pid
PIDFILE=/private/var/run/openconnect.pid

# Path to you openssl configuration
# Linux
# OPENSSL_CONF=/usr/share/openconnect/openssl.conf
# MacOS
OPENSSL_CONF=/private/var/openconnect/openssl.conf

# Path to the csd-post script
# Linux
#CSD_WRAPPER=/usr/share/openconnect/csd-post.sh
# MacOS
CSD_WRAPPER=/private/var/openconnect/csd-post.sh

# Path to the vpn-slice plugin
# Linux
VPN_SLICE=/usr/local/bin/vpn-slice
# MacOS
#VPN_SLICE=/opt/homebrew/bin/vpn-slice

# Default profile to use if not provided
DEFAULT_PROFILE=""

# Protocol to use with openconnect (e.g. anyconnect, fortinet, gp, pulse).
# Leave unset to let openconnect auto-detect.
# Can be overridden per profile via VPN_PROTOCOL.
# VPN_PROTOCOL=""

# ##################################### #
# DON'T CHANGE ANYTHING BELOW THIS LINE #
# ##################################### #

# Capture the directory of this file at source time, regardless of CWD.
# ${(%):-%x} resolves to the path of the file being sourced in zsh.
_VPN_SCRIPT_DIR="${${(%):-%x}:A:h}"

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

__vpn_log_warn() {
  echo -e "🤯 ${YELLOW}${1}${NC}"
}

__vpn_log_info() {
  echo -e "${GREEN}${1}${NC}"
}

__vpn_join_array() {
  local result=""
  for element in "$@"; do
    result+="${element} "
  done
  # Remove trailing space
  result="${result%" "}"
  echo "$result"
}

# Check if commands are installed
for i in ${CMDS[@]}; do
  command -v $i >/dev/null && continue || {
    __vpn_log_warn "$i doesn't seem to be installed. You should probably install it."
    return
  }
done

__vpn_check_sudo() {
  if [[ "$EUID" != 0 ]]; then
    __vpn_log_warn "Not enough privileges. Please run the script again with sudo!"
    return 1
  fi
  return 0
}

__vpn_load_profile() {
  local profile=$1
  local script_dir="$_VPN_SCRIPT_DIR"
  local profile_file="${script_dir}/vpn.${profile}.sh"

  if [[ ! -f "$profile_file" ]]; then
    __vpn_log_warn "Profile '${profile}' not found."
    echo "Available profiles:"
    for f in "${script_dir}"/vpn.*.sh; do
      echo "  ${${f:t:r}#vpn.}"
    done
    return 1
  fi

  # Reset profile-specific variables before sourcing
  unset REMOTE VPN_USER VPN_PASSWORD tunnel_nets

  source "$profile_file"

  if [[ -z "$REMOTE" || -z "$VPN_USER" ]]; then
    __vpn_log_warn "Profile '${profile}' must define REMOTE and VPN_USER."
    return 1
  fi

  TUNNEL_NETWORKS=$(__vpn_join_array "${tunnel_nets[@]}")
  export TUNNEL_NETWORKS
}

__vpn_list_profiles() {
  local script_dir="$_VPN_SCRIPT_DIR"
  local found=0
  for f in "${script_dir}"/vpn.*.sh; do
    echo "  ${${f:t:r}#vpn.}"
    found=1
  done
  if [[ $found -eq 0 ]]; then
    echo "  (no profiles found in ${script_dir})"
  fi
}

__vpn_connect() {
  for var in REMOTE VPN_USER PIDFILE CSD_WRAPPER VPN_SLICE OPENSSL_CONF VPN_USERAGENT; do
    if [[ -z "${(P)var}" ]]; then
      __vpn_log_warn "Required variable \$${var} is not set."
      return 1
    fi
  done

  # Some servers require sending user agent, this comment is just for keepsake
  # "--os=win --version-string='AnyConnect' --useragent="AnyConnect Windows 13.38"

  local slice_cmd="${VPN_SLICE}${TUNNEL_NETWORKS:+ ${TUNNEL_NETWORKS}}"

  __vpn_log_info "⚡️ Connecting to ${REMOTE} as ${VPN_USER} ‥"
  if [[ -z "${VPN_PASSWORD}" ]]; then
    OPENSSL_CONF=$OPENSSL_CONF sudo openconnect -v $REMOTE --user $VPN_USER --csd-wrapper $CSD_WRAPPER --background --useragent=$VPN_USERAGENT --protocol=$VPN_PROTOCOL --pid-file $PIDFILE --quiet -s "${slice_cmd}"
  else
    echo $VPN_PASSWORD | OPENSSL_CONF=$OPENSSL_CONF sudo openconnect -v $REMOTE --user $VPN_USER --passwd-on-stdin --csd-wrapper $CSD_WRAPPER --background --useragent=$VPN_USERAGENT --protocol=$VPN_PROTOCOL --pid-file $PIDFILE --quiet -s "${slice_cmd}"
  fi

}

__vpn_disconnect() {
  local pidfile=$1
  if test -f "$pidfile"; then
    __vpn_log_info "💀 Disconnecting ‥ "
    sudo /bin/kill $(cat $pidfile)
    return
  fi
  __vpn_log_info "Not connected"
}

__vpn_reconnect() {
  local pidfile=$1
  if test -f "$pidfile"; then
    __vpn_log_info "🌙 Reconnecting ‥"
    sudo /bin/kill -USR2 $(cat $pidfile)
    return
  fi
  __vpn_log_info "Not connected ‥"
}

__vpn_status() {
  local pidfile=$1

  if [[ ! -f "$pidfile" ]]; then
    __vpn_log_info "Not connected"
    return
  fi

  local pid=$(cat "$pidfile")

  if ! sudo /bin/kill -0 "$pid" 2>/dev/null; then
    __vpn_log_warn "Not connected (stale pidfile: ${pidfile})"
    return
  fi

  # Find tunnel interface and IP — utun* on macOS, tun* on Linux
  local iface ip
  if command -v ifconfig >/dev/null; then
    local ifinfo
    ifinfo=$(ifconfig 2>/dev/null | awk '
      /^(utun|tun)[0-9]/ { iface = substr($1, 1, length($1)-1) }
      /inet [0-9]/ && iface != "" { print iface, $2; iface="" }
    ')
    iface=$(echo "$ifinfo" | awk 'NR==1{print $1}')
    ip=$(echo "$ifinfo" | awk 'NR==1{print $2}')
  elif command -v ip >/dev/null; then
    iface=$(ip -o addr show 2>/dev/null | awk '/tun[0-9].*inet /{print $2; exit}')
    ip=$(ip -o addr show "$iface" 2>/dev/null | awk '{split($4,a,"/"); print a[1]; exit}')
  fi

  __vpn_log_info "Connected"
  echo "  PID      : ${pid}"
  if [[ -n "$iface" ]]; then
    echo "  Interface: ${iface}"
  fi
  if [[ -n "$ip" ]]; then
    echo "  Address  : ${ip}"
  fi
}

# Experimental. This adds a host to /etc/hosts as well as a static route while the tunnel is up.
# Currently only tested on in MacOS
__vpn_add_host() {
  if [[ $# < 2 ]]; then
    {
      p="$(basename $0)"
      echo "usage:  $p [vpn_name] [domain1] ..."
      echo
      echo "This script does the following:"
      echo "  1) Looks up the named domain(s) on the DNS servers for a VPN connection created"
      echo "     with the help of vpn-slice"
      echo "  2) Adds the ones that are found to /etc/hosts"
      echo "  3) Routes traffic to those hosts via the named VPN connection"
      echo
      echo "In other words, it does what vpn-slice WOULD HAVE DONE if you'd listed these"
      echo "specific hostnames in its command line as invoked AT CONNECTION TIME."
      echo
      echo "THESE CHANGES ARE TEMPORARY and won't persist past the lifetime of the VPN connection"
      return
    } >&2
  fi
  vpn="$1"
  shift 1
  BLOB=$(perl -ne 'print if /\bdns\d+\.$vpn\b.+\#.+/' /etc/hosts | cut -d\# -f2 | tail -n1)
  declare -a DNS=($(perl -ne 'print if /\bdns\d+\.$vpn/' /etc/hosts | sort | uniq))
  if [[ ! "$DNS[*]" ]]; then
    echo "ERROR: can't find dnsX.${vpn} in /etc/hosts -- is ${vpn} VPN up?" >&2
    return
  fi
  for hostname in "$@"; do
    ip=$(dig +short ${DNS[@]/#/@} "$hostname" | tail -n1)
    if [[ ! "$?" || -z "$ip" ]]; then
      echo "ERROR: couldn't find $hostname on $vpn DNS servers" >&2
    else
      echo "Found $hostname at IP address $ip on $vpn DNS servers" >&2
      sudo route add -host "$ip" -interface "$vpn" && echo "$ip $hostname $BLOB" | sudo tee -a /etc/hosts >/dev/null
      if [[ ! "$?" ]]; then
        echo "ERROR: couldn't configure $hostname properly" >&2
      fi
    fi
  done
}

__vpn_reload() {
  source "$_VPN_SCRIPT_DIR/vpn.sh" && __vpn_log_info "Reloaded $_VPN_SCRIPT_DIR/vpn.sh"
}

__vpn_usage() {
  echo "usage:  vpn [connect|disconnect|reconnect|status|list|reload|add-host]"
  echo
  echo "Commands:"
  echo "  connect [profile]   Connect using a named profile (default: ${DEFAULT_PROFILE})"
  echo "  disconnect          Disconnect the active VPN tunnel"
  echo "  reconnect           Reconnect the active VPN tunnel"
  echo "  status              Show tunnel status"
  echo "  list                List available profiles"
  echo "  reload              Reload vpn.sh into the current shell session"
  echo "  add-host [vpn] [host...]  Add hosts to /etc/hosts for a VPN connection"
}

# Entrypoint function
vpn() {

  if [[ $# < 1 ]]; then
    {
      __vpn_usage
      return
    } >&2
  fi

  case "$1" in
  'connect')

    local profile=${2:-$DEFAULT_PROFILE}

    if [[ -z "$profile" ]]; then
      echo "Available profiles:"
      __vpn_list_profiles
      echo
      read "profile?Profile: "
    fi

    __vpn_load_profile "$profile" || return 1

    __vpn_connect

    ;;
  'disconnect')
    __vpn_disconnect $PIDFILE
    ;;
  'reconnect')
    __vpn_reconnect $PIDFILE
    ;;
  'status')
    __vpn_status $PIDFILE
    ;;
  'list')
    echo "Available profiles:"
    __vpn_list_profiles
    ;;
  'reload')
    __vpn_reload
    ;;
  'add-host')
    __vpn_add_host $2 $3
    ;;
  *)
    __vpn_usage
    ;;
  esac

}
