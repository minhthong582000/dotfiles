# PATH and environment

# uv / local tools
[[ -r "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"
(( $+commands[go] )) && export PATH="$(go env GOPATH)/bin:$PATH"

typeset -U path  # dedupe PATH entries
