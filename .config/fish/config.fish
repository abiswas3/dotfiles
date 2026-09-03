if status is-interactive
    # Commands to run in interactive sessions can go here
      # echo (whoami)@(hostname) (date '+%Y-%m-%d %H:%M:%S') (pwd)

end
# Starship prompt — binary installed via brew (mac) / pacman (arch), NOT cargo.
# `starship init fish` prints fish glue that defines fish_prompt; `source` loads it.
starship init fish | source

# PATH additions. `-g` keeps them in the global (per-shell) PATH instead of
# the universal `fish_user_paths`, so this file stays the single source of
# truth. `fish_add_path` skips entries that don't exist or are already there.
fish_add_path -g $HOME/.cargo/bin       # cargo install
fish_add_path -g $HOME/go/bin           # go install
fish_add_path -g $HOME/.opencode/bin    # opencode
fish_add_path -g $HOME/.local/bin       # user-installed binaries
fish_add_path -g $HOME/.elan/bin        # elan: lake / lean / leanc


# Tangent task manager — data directory
# set -gx TANGENT_DATA_DIR $HOME/Projects/my-org-data

# Research manager — project root used by `scribe` (server) and `timbuktu` (TUI).
# Per-machine override: `set -Ux RESEARCH_MANAGER_DIR /your/path` (universal var).
# If unset, fall back to ~/Projects/research-manager when it exists. This keeps
# the dotfile portable across mac/linux without hardcoding either layout.
if not set -q RESEARCH_MANAGER_DIR
    if test -d $HOME/Projects/research-manager
        set -gx RESEARCH_MANAGER_DIR $HOME/Projects/research-manager
    end
end

# Aliases 
alias ll='ls -lah'
alias g='git'
alias vi='nvim'
alias zl="zellij"
alias lg="lazygit"
alias ls="eza --icons=always"
alias research-manager="cd ~/Projects/research-manager/"
alias syncer="ssh -i ~/.ssh/digitalocean root@64.23.233.221"

function macminiPrivate
    env TERM=xterm-256color ssh \
        -i ~/.ssh/macmini_ed25519 \
        primoz@192.168.0.13 $argv
end


function macminiPublic
    env TERM=xterm-256color ssh \
        -i ~/.ssh/macmini_ed25519 \
        -p 2223 \
        primoz@82.1.47.234 $argv
end

# Top 5 processes by memory. ps flags differ between GNU (Linux) and BSD (macOS).
function mem
    echo "PID        PROCESS                  MEM (MB)"
    echo "─────────────────────────────────────────────"
    ps aux | sort -k 6 -nr | head -5 | awk '{printf "%-8s   %-24s %6d MB\n", $2, $11, $6/1024}'
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


function rsyncFolder
    set -l usage \
        "Usage:" \
        "  rsyncFolder push LOCAL_SOURCE REMOTE_DIRECTORY" \
        "  rsyncFolder pull REMOTE_SOURCE LOCAL_DIRECTORY" \
        "" \
        "Examples:" \
        "  rsyncFolder push ./project/ '~/Documents/project/'" \
        "  rsyncFolder pull '~/Documents/project/' ./project/"

    if test (count $argv) -eq 1; and contains -- "$argv[1]" -h --help
        printf '%s\n' $usage
        return 0
    end

    if test (count $argv) -ne 3
        echo "Error: expected a direction and two paths." >&2
        printf '%s\n' $usage >&2
        return 2
    end

    set -l direction "$argv[1]"
    set -l source "$argv[2]"
    set -l destination "$argv[3]"
    set -l remote_home /Users/primoz
    set -l remote_path

    if not contains -- "$direction" push pull
        echo "Error: direction must be 'push' or 'pull'." >&2
        printf '%s\n' $usage >&2
        return 2
    end

    if test "$direction" = push
        set remote_path "$destination"
    else
        set remote_path "$source"
    end

    if test "$remote_path" = '~'
        set remote_path $remote_home
    else if string match -q '~/*' -- "$remote_path"
        set remote_path (string replace '~' "$remote_home" -- "$remote_path")
    else if test "$remote_path" = "$HOME"
        set remote_path $remote_home
    else if string match -q "$HOME/*" -- "$remote_path"
        set remote_path (string replace "$HOME" "$remote_home" -- "$remote_path")
    end

    set -l remote "primoz@82.1.47.234:$remote_path"
    set -l ssh_command "ssh -i $HOME/.ssh/macmini_ed25519 -p 2223"

    if test "$direction" = push
        command rsync -avh --progress \
            --rsh="$ssh_command" \
            -- "$source" "$remote"
    else
        command rsync -avh --progress \
            --rsh="$ssh_command" \
            -- "$remote" "$destination"
    end
end

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/Users/francis/.opam/opam-init/init.fish' && source '/Users/francis/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
