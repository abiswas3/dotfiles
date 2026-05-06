if status is-interactive
    # Commands to run in interactive sessions can go here
      # echo (whoami)@(hostname) (date '+%Y-%m-%d %H:%M:%S') (pwd)

end
# Starship prompt — binary installed via brew (mac) / pacman (arch), NOT cargo.
# `starship init fish` prints fish glue that defines fish_prompt; `source` loads it.
starship init fish | source

# Rust cargo
set -x PATH $HOME/.cargo/bin $PATH

# Go binaries (go install puts binaries here)
fish_add_path -g $HOME/go/bin
# opencode (HOME-relative so it works on Linux too)
fish_add_path -g $HOME/.opencode/bin
export PATH="$HOME/.local/bin:$PATH"


# Tangent task manager — data directory
# set -gx TANGENT_DATA_DIR $HOME/Projects/my-org-data

# Aliases 
alias ll='ls -lah'
alias g='git'
alias vi='nvim'
alias zl="zellij"
alias lg="lazygit"
alias ls="eza --icons=always"
alias syncer="ssh -i ~/.ssh/digocean root@64.23.233.221"

# Top 5 processes by memory. ps flags differ between GNU (Linux) and BSD (macOS).
function mem
    if test (uname) = Darwin
        # top reads phys_footprint, which matches Activity Monitor's "Memory" column.
        # ps rss double-counts shared libs and ignores compressed memory on macOS.
        top -l 1 -o mem -n 5 -stats command,mem | awk '
            /^COMMAND/ { found = 1; printf "  %-20s  %s\n", "PROCESS", "MEM"; next }
            found && NF { mem = $NF; $NF = ""; sub(/ +$/, ""); printf "  %-20s  %s\n", $0, mem }'
    else
        printf "  %-20s  %s  %s\n" PROCESS MEM% RSS
        ps -eo pmem,rss,comm | sort -k 1 -nr | head -5 | awk '{
            mem = $1; rss_kb = $2; $1 = ""; $2 = ""; sub(/^ +/, "")
            n = split($0, p, "/")
            printf "  %-20s  %4.1f  %4d MB\n", p[n], mem, rss_kb / 1024
        }'
    end
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


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/Users/francis/.opam/opam-init/init.fish' && source '/Users/francis/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
