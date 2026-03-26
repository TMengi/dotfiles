#!/usr/bin/env bash
set -euo pipefail

STOW_ROOT="$(dirname $0)"
echo "Stowing from $STOW_ROOT"

# Main stow command
stow --dir=$STOW_ROOT --target=$HOME .

# Separate script for storing desktop application files
$STOW_ROOT/applications/stow_apps.sh

echo "Done"
