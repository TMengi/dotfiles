#!/usr/bin/env bash
set -euo pipefail

USER="$(whoami)"

function print_header() {
  echo ''
  echo '################################################################################'
  echo "# $1"
  echo '################################################################################'
}

EXTRAS_DIR="$HOME/tools"
if [[ ! -d $EXTRAS_DIR ]]; then
  mkdir $EXTRAS_DIR
fi
cat >$EXTRAS_DIR/README.md <<EOF
User-owned directory for extra things that need to be installed and shouldn't
live in a privileged location
EOF

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
print_header "Installing baseline software"

sudo apt install \
git \
curl \
gcc \
g++ \
cmake \
wl-clipboard \
stow \

###############################################################################
print_header "Installing shell"

sudo apt install zsh

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
# TODO zsh-completions

###############################################################################
print_header "Installing git tools"

function install_lazygit() {
  echo "Installing lazygit with tar"
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  LAZYGIT_TAR="lazygit.tar.gz"
  cd /tmp
  curl -Lo $LAZYGIT_TAR "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf $LAZYGIT_TAR lazygit
  sudo install lazygit /usr/local/bin
  rm $LAZYGIT_TAR lazygit
  # Remove the default config because we will use our own
  LAZYGIT_CONFIG="$HOME/.config/lazygit/config.yml"
  if [[ -e $LAZYGIT_CONFIG ]]; then
    rm $LAZYGIT_CONFIG
  fi
}
if [[ $(command -v lazygit) ]]; then
  echo "lazygit already installed"
else
  install_lazygit
fi

function install_diffsofancy() {
  echo "Installing diff-so-fancy with git"
  DIFF_SO_FANCY=$EXTRAS_DIR/diff-so-fancy
  git clone https://github.com/so-fancy/diff-so-fancy.git $DIFF_SO_FANCY
  sudo ln -s $DIFF_SO_FANCY/diff-so-fancy /usr/local/bin/
}
if [[ $(command -v diff-so-fancy) ]]; then
  echo "diff-so-fancy already installed"
else
  install_diffsofancy
fi

###############################################################################
print_header "Installing rust toolchain"

# Install rust and a few rust tools
if [[ "$(command -v rustup)" ]]; then
  echo "rustup already installed"
else
  echo "installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Check if a cargo crate is already installed, then install it
#
# Args:
#   $1: Name of the crate
#   $2: Name of the executable, if different from the crate
function cargo_check_or_install() {
  name=$1
  if [[ $# -lt 2 ]]; then
    executable=$name
  else
    executable=$2
  fi
  if [[ "$(command -v $executable)" ]]; then
    echo "$name already installed"
  else
    cargo install $name
  fi
}

cargo_check_or_install ripgrep rg

# Alacritty has a bunch of apt requirements
sudo apt install \
pkg-config \
libfreetype6-dev \
libfontconfig1-dev \
libxcb-xfixes0-dev \
libxkbcommon-dev \
python3 \

cargo_check_or_install alacritty

cargo_check_or_install zellij

cargo_check_or_install zoxide

cargo_check_or_install eza

###############################################################################
print_header "Boostrap complete!"
