function index --description "Index a PDF into the research-manager library"
    if test (count $argv) -lt 1
        echo "usage: index <path-to-pdf> [--title ...] [--authors ...] [--notes ...]" >&2
        return 1
    end
    scribe import $argv
end
