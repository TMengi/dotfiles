#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
echo "Stowing from $REPO_ROOT"

$(cd $REPO_ROOT && stow .)
echo "Done"
