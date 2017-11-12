#!/bin/bash
#
# Sets up my Linux environment just the way i like it
#
install() {

    echo "Checking environment"
    for c in screen git ssh; do
      echo "- '$c'"
      if ! [ -x "$(command -v $c)" ]; then
        echo "Abort. '$c' is not installed."
        exit 1
      fi
    done

    echo "Creating folders"
    for d in ~/Documents/git/ ~/.ssh/ ~/.scripts/; do
      mkdir -m 755 -p $d
      echo "- '$d'"
    done

    echo "Moving dotfiles into place"
    for f in $(find $(dirname $(dirname $0)) -type f \( -name ".*" -and -not -name ".git*" \)); do
      cp $f ~/$(basename $f)
      echo "- '$f'"
    done

    echo "Moving scripts into place"
    for s in $(find "$(dirname $(dirname $0))/scripts/" -type f); do
      cp $s ~/.scripts/$(basename $s)
      chmod +x ~/.scripts/$(basename $s)
      echo "- '$s'"
    done

    echo "Moving .ssh/config into place"
    if [ -s ~/.ssh/config ] && [ "$1" = false ]; then
      echo "- WARN: '~/.ssh/config' exists and/or is not empty. Override with -f."
    else
      cp $(dirname $(dirname $0))/.ssh/config ~/.ssh/
      chmod 600 ~/.ssh/config
      echo "- done"
    fi

    echo -e "\nDone. Restart your shell session"

}

uninstall() {
  echo "Uninstalling"
}


if [ $# -lt 1 ]; then
    echo "Usage: $0 [install|uninstall]"
fi

case "$1" in
    '-f')
        install true
        ;;
    *)
        install false
esac
