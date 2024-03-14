# Set up the prompt
export ZSH_PLUGIN_DIRECTORY=~/.config/zsh/plugins

# Load zsh-autocomplete
source $ZSH_PLUGIN_DIRECTORY/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Load zsh-autosuggestions
source $ZSH_PLUGIN_DIRECTORY/zsh-autosuggestions/zsh-autosuggestions.zsh

# Adjust fpath for zsh-completions
fpath=($ZSH_PLUGIN_DIRECTORY/zsh-completions/src $fpath)

# Configuration for zsh-autocomplete
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

# Use Ctrl+Space to trigger completion if there's an ongoing suggestion
bindkey '^ ' autosuggest-accept

# Modify Tab behavior to accept suggestion first, then trigger completion
function zsh-autosuggest-accept-and-complete() {
  zle menu-complete
  zle autosuggest-accept
}
zle -N zsh-autosuggest-accept-and-complete
bindkey '^I' zsh-autosuggest-accept-and-complete

# Optional: Bind Shift+Tab to reverse completion
bindkey "$terminfo[kcbt]" reverse-menu-complete


# Syntax Highlighting
source $ZSH_PLUGIN_DIRECTORY/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

if command -v zoxide > /dev/null; then
   eval "$(zoxide init zsh)"
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# emacs keybindings
bindkey -e

#EDITOR
export EDITOR=nvim
export VISUAL=nvim

#alias
if command -v batcat > /dev/null; then
   alias cat=batcat
fi
if command -v lsd > /dev/null; then
   alias ls=lsd
fi

#starship
eval "$(starship init zsh)"

bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
