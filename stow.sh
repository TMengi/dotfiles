#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
echo "Stowing from $repo_root"

$(cd $repo_root && stow .)
