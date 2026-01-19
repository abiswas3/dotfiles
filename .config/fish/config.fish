if status is-interactive
    # Commands to run in interactive sessions can go here
      # echo (whoami)@(hostname) (date '+%Y-%m-%d %H:%M:%S') (pwd)

end
starship init fish | source

alias ll='ls -lah'
alias g='git'
alias vi='nvim'
alias zl="zellij"
alias lg="lazygit"
alias ls="eza --icons=always"
