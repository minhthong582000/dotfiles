# Plugins installed via Homebrew (see Brewfile).
# zsh-syntax-highlighting must be sourced last, so keep this file last in conf.d.
_brew_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"

if [[ -r "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

[[ -r "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unset _brew_share
