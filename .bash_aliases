# Re-attach to a screen, create a screen if none exists
alias s='if screen -list | grep Dead; then echo -e \"There are at least 1 dead session.\n1 = Wipe and start new\n2 = Just start new\n3 = Quit\" && read line; else screen -R; fi && if (("$line" == "1")); then screen -wipe; screen -R; elif (("$line" == "2")); then screen -R; fi;'

# Java Select menu
alias jh=". ~/.scripts/java_select.sh" 

# Rails cygwin fix
#alias rails="C:/Apps/RailsInstaller/Ruby1.9.3/bin/rails"
#alias bundle="C:/Apps/RailsInstaller/Ruby1.9.3/bin/bundle"
#alias rake="C:/Apps/RailsInstaller/Ruby1.9.3/bin/rake"

# ls aliases
alias l='ls -lh'
alias ll='ls -lah'

# cd aliases
alias ewh="cd /cygdrive/c/Users/F2530158/workspace && pwd"
