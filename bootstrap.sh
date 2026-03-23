#!/usr/bin/env bash
set -euo pipefail

DOTFILES_BASE=$(dirname $0)

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
if [[ ! -f $EXTRAS_DIR/README.md ]]; then
  cat >$EXTRAS_DIR/README.md <<EOF
User-owned directory for extra things that need to be installed and shouldn't
live in a privileged location
EOF
fi

# Obtain latest release version from Github
#
# Args:
#   $1: Github owner and repository name in the form "owner/repo"
#
# Returns:
#   Version in the form "vX.Y.Z"
function get_github_release_version() {
  local OWNER_REPO=$1
  local ENDPOINT="https://api.github.com/repos/$OWNER_REPO/releases/latest"
  local VERSION_RESULT=$(curl -s $ENDPOINT | jq -r '.tag_name')
  if [[ -z $VERSION_RESULT ]]; then
    echo "Could not detect version for $OWNER_REPO"
    exit 1
  fi
  echo $VERSION_RESULT
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
fd-find \

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
  local PLUGIN_DIR="$ZSH_PLUGINS/$1"
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
  local LAZYGIT_VERSION=${lazygit_version:-$(get_github_release_version jesseduffield/lazygit)}
  echo "Installing lazygit $LAZYGIT_VERSION from github release"

  # Remove the symlink to our config because the intallation will overwrite it
  local LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"
  if [[ -e $LAZYGIT_CONFIG_DIR ]]; then
    rm -r $LAZYGIT_CONFIG_DIR
  fi

  local LAZYGIT_ENDPOINT="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  curl -fsSL $LAZYGIT_ENDPOINT | sudo tar -xvz -C /usr/local/bin lazygit

  # Remove the automatically created config
  rm -r $LAZYGIT_CONFIG_DIR
}
if [[ $(command -v lazygit) ]]; then
  echo "lazygit already installed"
else
  install_lazygit
fi

function install_diffsofancy() {
  echo "Installing diff-so-fancy from git repo"
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
print_header "Installing neovim"

function install_nvim() {
  # Use supplied version or query for latest
  local NVIM_VERSION=${nvim_version:-$(get_github_release_version neovim/neovim)}
  echo "Installing nvim $NVIM_VERSION from github release"

  # Download the endpoint to a tmpdir
  local NVIM_TMP_PATH=/tmp/nvim.appimage
  local NVIM_ENDPOINT="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.appimage"
  curl -fsSL $NVIM_ENDPOINT -o $NVIM_TMP_PATH

  # Extract the appimage and move to final location
  chmod +x $NVIM_TMP_PATH
  $(cd $(dirname $NVIM_TMP_PATH) && $NVIM_TMP_PATH --appimage-extract)
  local EXTRACTED_PATH=$(dirname $NVIM_TMP_PATH)/squashfs-root
  sudo mv $EXTRACTED_PATH /opt/nvim
  sudo ln -sf /opt/nvim/AppRun /usr/local/bin/nvim

  # Cleanup
  rm $NVIM_TMP_PATH
}
if [[ $(command -v nvim) ]]; then
  echo "nvim already installed"
else
  install_nvim
fi

###############################################################################
print_header "Installing fzf"

function install_fzf() {
  local FZF_VERSION=$(get_github_release_version junegunn/fzf)
  echo "Installing fzf $FZF_VERSION from github release"
  local FZF_ENDPOINT="https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION#v}-linux_amd64.tar.gz"
  curl -fsSL $FZF_ENDPOINT | sudo tar -xvz -C /usr/local/bin fzf
}
if [[ $(command -v fzf) ]]; then
  echo "fzf already installed"
else
  install_fzf
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
  local name=$1
  local executable=${2:-$name}
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
python3

cargo_check_or_install alacritty

cargo_check_or_install zellij

cargo_check_or_install zoxide

cargo_check_or_install eza

cargo_check_or_install atuin

###############################################################################
print_header "Stowing configs"
$DOTFILES_BASE/stow.sh

###############################################################################
print_header "Boostrap complete!"
