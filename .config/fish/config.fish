if status is-interactive
    # Commands to run in interactive sessions can go here
      # echo (whoami)@(hostname) (date '+%Y-%m-%d %H:%M:%S') (pwd)

end
starship init fish | source
# Rust cargo
set -x PATH $HOME/.cargo/bin $PATH
alias ll='ls -lah'
alias g='git'
alias vi='nvim'
alias zl="zellij"
alias lg="lazygit"
alias ls="eza --icons=always"

function mem
 ps -eo pmem,pcpu,vsize,pid,cmd | sort -k 1 -nr | head -5
 end 
function grep-dir
    # Run ripgrep on all files, pipe to fzf TUI with exact match
    rg --no-heading --line-number --column --hidden . | \
    fzf --layout=reverse --ansi --exact \
        --preview 'IFS=: read -r file line col rest <<< "{}"; bat --style=numbers --color=always "$file" --highlight-line "$line"' \
        | while read -l line
            # Split RG output line into filename and line number
            set file (string split ":" $line)[1]
            set line_no (string split ":" $line)[2]
            # Open selected file at the correct line in nvim
            nvim +"$line_no" "$file"
        end
end
# opencode
fish_add_path /Users/francis/.opencode/bin
export PATH="$HOME/.local/bin:$PATH"
