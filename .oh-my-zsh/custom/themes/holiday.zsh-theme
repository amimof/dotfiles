HOLIDAY_ICON=""
# New years day
if (($(date +"%-m%-d") == 11)); then
   HOLIDAY_ICON="🤢 "
fi
# Easter
if (($(date +"%-m") >= 4)); then
   HOLIDAY_ICON="🐣 "
fi
# Walpurgis Night
if (($(date +"%-m%-d") == 430)); then
   HOLIDAY_ICON="🔥 "
fi
# 5th of May
if (($(date +"%-m%-d") == 51)); then
   HOLIDAY_ICON="🇨🇳 "
fi
# Swedens national day
if (($(date +"%-m%-d") == 66)); then
   HOLIDAY_ICON="🇸🇪 "
fi
# Midsummer: 19th to 25th of June
if (($(date +"%-m%-d") >= 619 && $(date +"%-m%-d") <= 626)); then
   HOLIDAY_ICON="☀️ "
fi
# Christmas: entire December month
if (($(date +"%-m") == 12)); then
   HOLIDAY_ICON="🎄 "
fi
# Christmas day
if (($(date +"%-m%-d") == 1225)); then
   HOLIDAY_ICON="🎅🏽 "
fi
# New years eve
if (($(date +"%-m%-d") == 1231)); then
   HOLIDAY_ICON="🍾 "
fi

# Default prompt
PROMPT='${HOLIDAY_ICON}%{$fg[cyan]%}%c%{$reset_color%} '
PROMPT+="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"




