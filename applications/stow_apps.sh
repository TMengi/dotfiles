#!/usr/bin/env bash
set -euo pipefail

SYS_APPS="/usr/share/applications"

STOW_APPS="$(dirname $(realpath $0))"
echo "Stowing applications from $STOW_APPS"

function setup_alacritty() {
  if [[ ! -h "$SYS_APPS/alacritty.desktop" ]]; then
    sudo ln -s alacritty.desktop $SYS_APPS/
  fi
  if [[ ! -h "/opt/alacritty/alacritty.svg" ]]; then
    sudo mkdir -p /opt/alacritty
    sudo ln -s alacritty.svg /opt/alacritty/
  fi
}
$(cd $STOW_APPS && setup_alacritty)
