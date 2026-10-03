#!/usr/bin/env bash
# Script to stow system applications. Cannot be built on GNU stow directly
# because we need to resolve the user home directory.
set -euo pipefail

# Source things from this repo
APPS_SOURCE="$(dirname $(realpath $0))"
echo "Stowing applications from $APPS_SOURCE"

# Cargo installed binary will live here
CARGO_HOME=${CARGO_HOME:-$HOME/.cargo}

# Destination for all launcher files and resources
USER_APPS="$HOME/.local/share/applications"
mkdir -p $USER_APPS

function setup_alacritty() {
  # Icon
  local ICON_DIR=$HOME/.local/share/icons/alacritty
  local ALACRITTY_ICON=$ICON_DIR/alacritty.svg
  mkdir -p $ICON_DIR
  if [[ ! -L "$ALACRITTY_ICON" ]]; then
    ln -s "$APPS_SOURCE/alacritty.svg" $ALACRITTY_ICON
  fi

  # Desktop launcher
  local ALACRITTY_EXEC=$CARGO_HOME/bin/alacritty
  if [[ ! -f "$USER_APPS/alacritty.desktop" ]]; then
    export ALACRITTY_EXEC ALACRITTY_ICON
    envsubst <$APPS_SOURCE/alacritty.desktop >$USER_APPS/alacritty.desktop
  fi
}
setup_alacritty
