# Put all your local configuration that shouldn't be publicly version
# controlled into here. It will be sourced near the end of this file.
export LOCAL_ZSHRC="$HOME/.local_zshrc"

# =============================================================================
# Path
# =============================================================================
function append_path() {
  export PATH=$PATH:$1
}

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
eval $(dircolors ~/.dir_colors/dircolors)

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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias path='echo $PATH | tr ":" "\n"'
if [[ $(command -v zoxide) ]]; then
  eval "$(zoxide init zsh)" && alias cd='z'
fi
if [[ $(command -v eza) ]]; then
  alias ls='eza'
  alias ll='eza -lagh --classify always'
  # Always ignore certain directories for tree view
  alias tree='eza -T --ignore-glob="venv|.git"'
fi
if [[ $(command -v atuin) ]]; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Tmux stuff
alias tls='tmux list-sessions'
alias tat='tmux a -t'

# Git aliases
alias g='git'
alias gs='git status -bs'
alias groot='cd $(git rev-parse --show-toplevel)'
alias gl='git lg'
alias lg='lazygit'
# Branches
alias gw='git switch'
alias gwc='git switch -c'
alias gwm='git switch master'
alias gwu='git switch @{upstream}'
alias gb='git branch -vv'
alias gbb='gb | grep "^\*"'
alias gbd='gb | grep -P "(?<=\[)$(git branch --show-current)"' # Downstream branches
alias gbg='gb | grep gone'
alias gbsutm='git branch --set-upstream-to master'
alias gbum='git branch -u master'
# Diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdm='git diff master'
alias gdu='git diff @{upstream}'
alias gdno='git diff --name-only'
alias gdmno='git diff master --name-only'
alias gduno='git diff @{upstream} --name-only'
alias gdo='git diff origin/"$(git branch --show-current)"'
# Commit
alias ga='git add'
alias gc='git commit'
alias gcm='git commit --message'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
# Push/pull
alias gp='git pull'
alias gpo='git push origin'
alias gponv='git push origin --no-verify'
# Merges and rebases
alias gm='git merge'
alias gr='git rebase'
alias grm='git rebase master'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
# Restore
alias grs='git restore'
alias grsm='git restore --source=master'
alias grsu='git restore --source=@{upstream}'
# Stash
alias gst='git stash'
alias gsl='git stash list'
alias gspm='git stash push -m'
alias gsa='git stash apply'
# Deprecated
alias gce='git checkout'
alias gcem='git checkout master'
alias gceu='git checkout @{upstream}'
alias gsuc='git submodule update --checkout'

# Forge tools aliases
alias gv='forge_tools view'
alias gfp='forge_tools fetch-prune'

# Zellij aliases
alias zj='zellij'

# Always use python 3
alias python='python3'

# Added for rust
source "$HOME/.cargo/env"

# Normal defaults for rsync
alias rsync='rsync -a --info=progress2'
# Rsync in non-archive mode. Useful for transfering to NFS shares where user
# operations are mapped to a user on the remote host.
alias rsync_noa='rsync --no-owner --no-group --no-perms --no-times'

alias da='deactivate'

# kubernetes aliases
alias k='kubectl'
alias kp='k get pods'

# =============================================================================
# FZF
# =============================================================================
# File and directory search
FZF_IGNORE_DIRS='.git,node_modules,target'
FZF_CTRL_T_COMMAND='fdfind'
FZF_CTRL_T_OPTS=$(
  cat <<EOF
--walker-skip $FZF_IGNORE_DIRS
--preview 'batcat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
--border
EOF
)

# Directory-only search
FZF_ALT_C_COMMAND='fdfind -td'
FZF_ALT_C_OPTS=$(
  cat <<EOF
--walker-skip $FZF_IGNORE_DIRS
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

# Disable ctrl-R since that's handled by atuin
FZF_CTRL_R_COMMAND=

source <(fzf --zsh)

function _fzf_complete_git() {
  local subcommand="$(awk '{print $2}' <<<$1)"
  case "$subcommand" in
  branch | checkout | switch | merge | rebase)
    local search_command="git branch --sort=-committerdate | tr -d ' *'"
    ;;
  *)
    local search_command="_fzf_compgen_path *"
    ;;
  esac
  _fzf_complete --multi --reverse --prompt="$@" -- "$@" < <(eval $search_command)
}

for aylias in gb gce gw gm gr; do
  _full_command="$(whence $aylias)"
  source <(
    cat <<EOF
_fzf_complete_${aylias}() {
  shift
  _fzf_complete_git '$_full_command ' \$@
}
EOF
  )
done

# Environment variables with or without values shown
alias fzenv='printenv | fzf'
alias fzenvp='printenv | cut --delimiter = --fields 1 | fzf --preview "printenv {}"'

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
    branch=$(git branch --show-current | cut -b 1-40)
  fi
  [[ -n "$branch" ]] && echo "%F{yellow}<$branch> %f"
}
BRANCH="\$(git_prompt)"
if [[ $(command -v "virtualenv_info") ]]; then # This should be defined in $LOCAL_ZSHRC
  VENV='$(virtualenv_info)'
fi
PS1="
╭─${VENV}%F{green}%n%f %B%F{blue}%~%f%b ${BRANCH}
╰─➤ "
# Put the clock on the right side of the prompt
_lineup=$'\e[1A'
_linedown=$'\e[1B'
RPROMPT="%{${_lineup}%}%*%{${_linedown}%}"
