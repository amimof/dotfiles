#
# Stylizes your Zsh prompt by adding emojis to it whenever there is a Swedish holiday.
#
# To use, add the following to ~/.zshrc
#   [ -f ~/.zsh/swe-holiday-prompt.zsh ] && source ~/.zsh/swe-holiday-prompt.zsh
#
autoload -U colors && colors

# Disable promptinit if it is loaded
(( $+functions[promptinit] )) && {promptinit; prompt off}

# Allow parameter and command substitution in the prompt
setopt PROMPT_SUBST

# Override PROMPT if it does not use the gitprompt function
[[ "$PROMPT" != *swe_prompt* ]] \
    && NEWPROMPT='$(swe_prompt)' \
    && NEWPROMPT+=$PROMPT \
    && PROMPT=$NEWPROMPT

# The hash map holding the dates and respective icon. map[date]=emoji
# The format of the map key (date) should be `date +"%m%d"`
typeset -A holidays

# Helper function to calculate the start and end timestamps based on OS
# Check for MacOS and if it isn't assume it's Linux
_calculate_range() {
  if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "FreeBSD" ]; then
    echo $(date -j -f "%Y%m%d" $1 "+%s")
  else
    echo $(date -d "$1" "+%s")
  fi
}

# Helper function to convert a timestamp to a month-day key based on OS
# Check for MacOS and if it isn't assume it's Linux
_convert_to_key() {
  if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "FreeBSD" ]; then
    echo $(date -j -f "%s" $1 "+%m%d")
  else
    echo $(date -d "@$1" "+%m%d")
  fi
}

# Adds a range of dates to the map of emojis. Takes 4 arguments
# _add_range <start> <end> <emoji> <description>
_add_range() {
  _year=$(date +"%Y")
  _icon=$3
  _description=$4

  _starts=$(_calculate_range "${_year}$1")
  _ends=$(_calculate_range "${_year}$2")
  _count=$((($_ends - $_starts) / 86400 + 1))

  for i in $(seq $_count); do
    _add_starts=$(($_starts + 86400 * (i - 1)))
    _key=$(_convert_to_key $_add_starts)
    holidays[$_key]="$_icon|$_description"
  done
}

# New year
_add_range 0101 0102 🤢 "Nyårsdagen"

# Easter
_add_range 0322 0325 🐣 "Påsk"

# TODO: Fettisdagen (tisdagen efter fastlagssöndagen) 🥯

# Våffeldagen
_add_range 0325 0326 🧇 "Våffeldagen - nom nom!"

# Valborgsmässoafton
_add_range 0430 0430 🔥 "Valborgsmässoafton"

# 1a Maj
_add_range 0430 0430 🟥 "1a Maj"

# TODO: Kristi himmelfärdsdag (40 dagar efter påsk) 🕊️

# TODO: Pingst (10 dagar efter kristi himmelfärdsdagen) ✝️

# Midsommar (hela juni)
_add_range 0601 0605 🌼 "Midsommar"

# Sveriges nationaldag
_add_range 0606 0607 🇸🇪 "Nationaldagen"

# Midsommar (hela juni)
_add_range 0608 0630 ☀️ "Midsommar"

# My birthday
_add_range 1022 1022 🧔🏽‍♂️

# Alla helgons dag (månadsskiftet oktober-november)
_add_range 1030 1102 👻 "Alla helgons dag"

# Advent (slutet av november-december)
_add_range 1130 1201 🕯️ "Advent (of code?)"

# Lucia
_add_range 1213 1213 👸 "Lucia"

# Christmas
_add_range 1214 1223 🎄 "Jul"
_add_range 1224 1225 🎁 "Jul"
_add_range 1226 1229 🎄 "Strålande jul"
_add_range 1230 1230 🥳 "Nyårsafton"

# Print which holiday it is
swe_holiday() {
  d=$(date +"%m%d")
  h=${holidays[$d]}
  desc=${h#*|}

  print $desc
}

# Main func
swe_prompt() {
  d=$(date +"%m%d")
  h=${holidays[$d]}
  e=${h%%|*}

  prompt=$e
  if [ ! -z $prompt ]; then
    prompt+=" "
  fi
  print "${prompt}"
}
