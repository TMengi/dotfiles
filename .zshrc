# Put all your local configuration that shouldn't be publicly version
# controlled into here. It will be sourced near the end of this file.
export LOCAL_ZSHRC="$HOME/.local_zshrc"

# =============================================================================
# Path
# =============================================================================
function append_path() {
  export PATH=$PATH:$1
}
append_path $HOME/bin
append_path $HOME/.local/bin
append_path /usr/local/bin

# =============================================================================
# ZSH configuration
# =============================================================================
# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Optionally change the custom folder
# ZSH_CUSTOM=$ZSH/custom

# Select a theme from $ZSH/themes
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gnzh"
eval `dircolors ~/.dir_colors/dircolors`

# Don't throw errors about unmatched globs
setopt CSH_NULL_GLOB

# Display red dots while waiting for completions
COMPLETION_WAITING_DOTS="true"
# Can also replace the red dots with another string e.g.
# COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

# List of plugins to load
# Standard plugins can be found in $ZSH/plugins
# Custom plugins may be added to $ZSH_CUSTOM/plugins
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bazel
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Completions and expansions
# =============================================================================
# Expand aliases with "C-x a" or tab
bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

# Allow for completion caching for things like bazel
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# =============================================================================
# Common aliases
# =============================================================================
# Use neovim everywhere
export EDITOR='nvim'
export VISUAL=$EDITOR
alias vim=$EDITOR
alias nvc='cd ~/.config/nvim'
export MANPAGER="$EDITOR +Man!"

# Quick edit shell configs
alias zshrc="$EDITOR ~/.zshrc"
alias lzshrc="$EDITOR $LOCAL_ZSHRC"

# Alias builtins and GNU standard tools
eval "$(zoxide init zsh)" && alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias path='echo $PATH | tr ":" "\n"'
alias ls='eza'
alias ll='eza -laghF'
alias tree='eza -T'
eval "$(atuin init zsh --disable-up-arrow)"

# Tmux stuff
alias tls='tmux list-sessions'
alias tat='tmux a -t'

# Git aliases
alias g='git'
alias gce='git checkout'
alias gw='git switch'
alias grs='git restore'
alias gp='git pull'
alias gd='git diff'
alias gb='git branch -vv'
alias ga='git add'
alias gr='git rebase'
alias gst='git stash'
alias gdu='git diff @{upstream}'
alias gdno='git diff --name-only'
alias gduno='git diff @{upstream} --name-only'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gl='git lg'
alias gcem='git checkout master'
alias gceu='git checkout @{upstream}'
alias gwm='git switch master'
alias gwu='git switch @{upstream}'
alias grsm='git restore --source=master'
alias grsu='git restore --source=@{upstream}'
alias gdm='git diff master'
alias gdmno='git diff master --name-only'
alias gds='git diff --staged'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
alias gsuc='git submodule update --checkout'
alias gbsutm='git branch --set-upstream-to master'
alias gbum='git branch -u master'
alias gsl='git stash list'
alias gspm='git stash push -m'
alias gsa='git stash apply'
alias grm='git rebase master'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gbb='gb | grep "^\*"'
alias gbd='gb | grep -P "(?<=\[)$(git branch --show-current)"'
alias gbg='gb | grep gone'
alias gfp='git fetch --prune'
alias gdo='git diff origin/"$(git branch --show-current)"'
alias lg='lazygit'
alias gpo='git push origin'
alias gponv='git push origin --no-verify'

# Displays previous git branches.
#
# Optional argument is the number of branches to display. Defaults to 5.
function gbp() {
  num_branches=${1:-5}
  for ((ii = 1; ii <= num_branches; ii++)); do
    local githash="$(git rev-parse @{-$ii})"
    local branch="$(git describe --all $githash)"
    echo "$ii: $branch"
  done
}

# Checks out a previous branch
#
# Argument is how many branches to go backwards. Branch numbering can be
# checked with gbp
function gcep() {
  git checkout @{$1}
}

# Zellij aliases
alias zj='zellij'

# Always use python 3
alias python='python3'

# Added for rust
source "$HOME/.cargo/env"

# Added for golang
export PATH=$PATH:/usr/local/go/bin

alias rsync='rsync -a --info=progress2'
alias da='deactivate'

# kubernetes aliases
alias k='kubectl'
alias kp='k get pods'

# =============================================================================
# FZF
# =============================================================================
# File and directory search
FZF_CTRL_T_COMMAND='fdfind'
FZF_CTRL_T_OPTS=$(cat <<EOF
--walker-skip .git,node_modules,target
--preview 'batcat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
--border
EOF
)

# Directory-only search
FZF_ALT_C_COMMAND='fdfind -td'
FZF_ALT_C_OPTS=$(cat <<EOF
--walker-skip .git,node_modules,target
--preview 'eza -T {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
--border
EOF
)

# Fuzzy completion
FZF_COMPLETION_OPTS='--border'
function _fzf_compgen_path() {
  fdfind --hidden --follow --exclude ".git" . "$1"
}
function _fzf_compgen_dir() {
  fdfind --type d --hidden --follow --exclude ".git" . "$1"
}

# Disable ctrl-R since that's used for atuin
FZF_CTRL_R_COMMAND= source <(fzf --zsh)

# =============================================================================
# Source local zshrc
# =============================================================================
# Do this just before declaring PS1 so that the local environment can define
# any extra prompt goodies
if [[ -f $LOCAL_ZSHRC ]]; then
  source $LOCAL_ZSHRC
fi

# =============================================================================
# PS1
# =============================================================================
function git_prompt() {
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z "$repo_root" ]; then
    branch=''
  else
    branch=`git branch --show-current | cut -b 1-40`
  fi
  [[ -n "$branch" ]] && echo "%F{yellow}<$branch> %f"
}
BRANCH="\$(git_prompt)"
if [[ $(command -v "virtualenv_info") ]]; then  # This should be defined in $LOCAL_ZSHRC
  VENV='$(virtualenv_info)'  # Purposefully not expanding the $
fi
PS1="
╭─${VENV}%F{green}%n%f %B%F{blue}%~%f%b ${BRANCH}
╰─➤ "
# Put the clock on the right side of the prompt
_lineup=$'\e[1A'
_linedown=$'\e[1B'
RPROMPT="%{${_lineup}%}%*%{${_linedown}%}"
