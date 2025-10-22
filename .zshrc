# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set nvim as default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load oh-my-zsh (THIS WAS MISSING!)
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias ll='ls -lah'
alias ls="eza --icons=always"
alias vi="nvim"
alias lg="lazygit"
alias zl="zellij"
# source $(brew --prefix)/opt/fzf/install
#
