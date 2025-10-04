#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
echo "Stowing from $REPO_ROOT"

# Main stow command
$(cd $REPO_ROOT && stow .)

# Separate script for storing desktop application files
$REPO_ROOT/applications/stow_apps.sh

echo "Done"
