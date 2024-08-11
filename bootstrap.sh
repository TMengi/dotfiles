#!/usr/bin/env bash
set -euo pipefail

USER="$(whoami)"

function print_header() {
  echo ''
  echo '################################################################################'
  echo "# $1"
  echo '################################################################################'
}

# DEPRECATED
# Check if something is already installed, then install it with apt
#
# Args:
#   $1: Command that can be checked to verify an existing install
#   $2: Apt endpoint for a new install. If not provided, assumed to equal $1
function apt_check_or_install() {
  COMMAND_CHECK=$1
  if [[ $# -lt 3 ]]; then
    COMMAND_INSTALL=$COMMAND_CHECK
  else
    COMMAND_INSTALL=$2
  fi

  if [[ "$(command -v $COMMAND_CHECK)" ]]; then
    echo "$COMMAND_INSTALL already installed"
  else
    echo "Installing $COMMAND_INSTALL"
    sudo apt install $COMMAND_INSTALL
  fi
}

###############################################################################
print_header "Install baseline software"

sudo apt install \
git \
curl \
gcc \
g++ \
cmake \
wl-clipboard \
stow \

function install_lazygit() {
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  LAZYGIT_TAR="lazygit.tar.gz"
  cd /tmp
  curl -Lo $LAZYGIT_TAR "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf $LAZYGIT_TAR lazygit
  sudo install lazygit /usr/local/bin
  rm $LAZYGIT_TAR lazygit
}
if [[ $(command -v lazygit) ]]; then
  echo "lazygit already installed"
else
  install_lazygit
fi

###############################################################################
print_header "Installing shell"

sudo apt install zsh
if [[ $SHELL == "$(which zsh)" ]]; then
  echo "SHELL is already zsh"
else
  echo "Setting SHELL to zsh"
  sudo chsh -s "$(which zsh)" $USER
fi
if [[ -e $ZSH ]]; then
  echo "oh-my-zsh already installed"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
ZSH_PLUGINS=$ZSH_CUSTOM/plugins
# Check if a zsh plugin is already installed, then install it with git clone
#
# Args:
#   $1: Directory to place a new install or verify an existing install,
#     relative to $ZSH_PLUGINS
#   $2: Git repo to clone a new install
function zsh_check_or_install() {
  PLUGIN_DIR="$ZSH_PLUGINS/$1"
  if [[ -e $PLUGIN_DIR ]]; then
    echo "$1 already installed"
  else
    echo "installing $1"
    git clone $2 $PLUGIN_DIR
  fi
}

zsh_check_or_install zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
zsh_check_or_install zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

###############################################################################
print_header "Installing rust toolchain"

# Install rust and a few rust tools
if [[ "$(command -v rustup)" ]]; then
  echo "rustup already installed"
else
  echo "installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
if [[ "$(command -v rg)" ]]; then
  echo "ripgrep already installed"
else
  echo "installing ripgrep"
  cargo install ripgrep
fi

# Alacritty has a bunch of apt requirements
sudo apt install \
pkg-config \
libfreetype6-dev \
libfontconfig1-dev \
libxcb-xfixes0-dev \
libxkbcommon-dev \
python3 \

cargo install alacritty

cargo install zellij

###############################################################################
print_header "Boostrap complete!"
