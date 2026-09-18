# Entry point: loads every module in conf.d/ in lexical order.
# Resolve the real location of this file (it is symlinked into $HOME).
export DOTFILES="${${(%):-%x}:A:h:h}"

for _f in "$DOTFILES"/zsh/conf.d/*.zsh(N); do
  source "$_f"
done
unset _f

# Machine-specific settings and secrets (tokens, keys) go here — never committed.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
