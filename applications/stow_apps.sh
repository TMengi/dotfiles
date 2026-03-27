#!/usr/bin/env bash
# Script to stow system applications. Cannot be built on GNU stow directly
# because these files are not under the home tree
set -euo pipefail

SYS_APPS="/usr/share/applications"

STOW_APPS="$(dirname $(realpath $0))"
echo "Stowing applications from $STOW_APPS"

function setup_alacritty() {
  # Application
  if [[ ! -h "$SYS_APPS/alacritty.desktop" ]]; then
    sudo ln -s $STOW_APPS/alacritty.desktop $SYS_APPS/alacritty.desktop
  fi
  # Shortcut
  sudo ln -sf $HOME/.cargo/bin/alacritty /usr/local/bin/alacritty
  # Icon
  ICON_DIR="/opt/alacritty"
  if [[ ! -h "$ICON_DIR/alacritty.svg" ]]; then
    sudo mkdir -p $ICON_DIR
    sudo ln -s "$STOW_APPS/alacritty.svg" $ICON_DIR/alacritty.svg
  fi
}
setup_alacritty
