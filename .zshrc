# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
# eval "$(zoxide init zsh)"
# alias cd="z"
alias vi="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

eval "$(rbenv init -)"

diff_branch_file() {
    if [ $# -ne 3 ]; then
        echo "Usage: diff_branch_file <branch1> <branch2> <full/path/to/file>"
        return 1
    fi

    local branch1=$1
    local branch2=$2
    local file=$3

    local tmp2="/tmp/$(basename $file)_$branch2"

    git show "$branch2:$file" > "$tmp2"

    nvim -d "$file" "$tmp2"
}

