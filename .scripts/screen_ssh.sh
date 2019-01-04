#!/bin/bash

#
# Use this script as an SSH LocalCommand within GNU Screen. After a successfull
# login, the Screen title will display the name of the remote host.
# 
# Add the following in ~/.ssh/config
#
# Host *
#     PermitLocalCommand yes 
#     LocalCommand /path/to/screen_ssh.sh %h %n
#

set -e
set -u
tty -s

if [ "$2" = "%n" ]; then
  HOST=$(xargs -0 < /proc/$1/cmdline)
else
  HOST="$2"
fi

echo $HOST | sed -e 's/\.[^.]*\.[^.]*\(\.uk\)\{0,1\}$//' | awk '{ printf ("\033k%s\033\\", $NF) }'