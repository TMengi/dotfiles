# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/home/tyler/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gnzh"
eval `dircolors ~/.dir_colors/dircolors`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$ZSH/custom

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

source /home/tyler/tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Expand aliases with "C-x a" or tab
bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

# PS1
function git_prompt() {
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z "$repo_root" ]; then
    branch=''
  else
    branch=`git branch | grep "^*" | cut -b 3-40`
  fi
  [[ -n "$branch" ]] && echo "%F{yellow}<$branch> %f"
}
BRANCH="\$(git_prompt)"
PS1="
╭─${VENV}%F{green}%n%f %B%F{blue}%~%f%b ${BRANCH}
╰─➤ "

# Put all your local configuration that shouldn't be publicly version
# controlled into here
export LOCAL_ZSHRC="$HOME/.local_zshrc"
if [[ -f $LOCAL_ZSHRC ]]; then
  source $LOCAL_ZSHRC
fi

# Use neovim everywhere
export EDITOR="nvim"
export VISUAL=$EDITOR
alias vim=$EDITOR

alias ll="ls -lahF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Tmux stuff
alias tls='tmux list-sessions'
alias tat='tmux a -t'

# Git aliases
alias g="git"
alias gce="git checkout"
alias gp="git pull"
alias gd="git diff"
alias gb="git branch -vv"
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
alias gdm='git diff master'
alias gdmno='git diff master --name-only'
alias gdem='gd external/monorepo'
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
alias gbd='git branch -vv | grep -P "(?<=\[)$(git branch --show-current)"'
alias gbg='git branch -vv | grep gone'
alias gfp='git fetch --prune'
alias gdo='git diff origin/"$(git branch --show-current)"'

# Zellij aliases
alias zj="zellij"
alias za="zj attach"
alias zls="zj list-sessions"

# Added for rust
source "$HOME/.cargo/env"

# Added for golang
export PATH=$PATH:/usr/local/go/bin
