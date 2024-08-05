#!/usr/bin/env bash
set -euo pipefail

SYS_APPS="/usr/share/applications"

STOW_APPS="$(dirname $(realpath $0))"
echo "Stowing applications from $STOW_APPS"

function setup_alacritty() {
  # Application
  if [[ ! -h "$SYS_APPS/alacritty.desktop" ]]; then
    cd $SYS_APPS
    sudo ln -s $STOW_APPS/alacritty.desktop
  fi
  # Icon
  ICON_DIR="/opt/alacritty"
  if [[ ! -h "$ICON_DIR/alacritty.svg" ]]; then
    sudo mkdir -p $ICON_DIR
    cd $ICON_DIR
    sudo ln -s "$STOW_APPS/alacritty.svg"
  fi
}
setup_alacritty
