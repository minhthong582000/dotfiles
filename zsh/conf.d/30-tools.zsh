# Tool integrations

# kubectl
if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  alias k=kubectl
  compdef _kubectl k
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# fzf: Ctrl-R history, Ctrl-T files, Alt-C cd, ** completion
(( $+commands[fzf] )) && source <(fzf --zsh)

# zoxide: `z foo` jumps to frequent dirs, `zi` picks with fzf
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
