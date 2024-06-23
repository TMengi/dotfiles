#!/usr/bin/env bash
set -euo pipefail

USER="$(whoami)"

function apt_check_or_install() {
  if [[ "$(command -v $1)" ]]; then
    echo "$1 already installed"
  else
    echo "installing $1"
    sudo apt install $1
  fi
}

# Install some baseline software
apt_check_or_install git
apt_check_or_install curl
apt_check_or_install gcc
apt_check_or_install g++
apt_check_or_install cmake

if [[ "$(command -v wl-copy)" ]]; then
  echo "wl-clipboard already installed"
else
  echo "installing wl-clipboard"
  sudo apt install wl-clipboard
fi

# Install zsh and omz
apt_check_or_install zsh
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
# TODO:
# zellij
# alacrity
# dircolors
# zsh-syntax-highlighting

echo "Boostrap completed!"
