#!/bin/bash
if [ -n "$STY" ]; then
    echo -ne "\033k$1\033\\"
else
    echo -ne "\e]0;$1\a"
fi
