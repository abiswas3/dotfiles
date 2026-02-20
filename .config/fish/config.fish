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
function gk
    set_color FCF392; echo "  git status symbols"
    set_color 8B8B8B; echo "  ─────────────────"
    set_color FF6E6E; echo "  ?  untracked"
    set_color FF6E6E; echo "  !  modified"
    set_color 7DF9AA; echo "  +  staged"
    set_color FF6E6E; echo "  ✘  conflicted"
    set_color FCF392; echo "  \$  stashed"
    set_color 7DF9AA; echo "  ⇡  ahead"
    set_color FF6E6E; echo "  ⇣  behind"
    set_color normal
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
