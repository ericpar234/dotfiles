# Set up the prompt

export ZSH_PLUGIN_DIRECTORY=~/.config/zsh/plugins

source $ZSH_PLUGIN_DIRECTORY/zsh-autocomplete/zsh-autocomplete.plugin.zsh
## tab into autocomplete menu
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

fpath=($ZSH_PLUGIN_DIRECTORY/zsh-completions/src $fpath)

# auto suggestions
source $ZSH_PLUGIN_DIRECTORY/zsh-autosuggestions/zsh-autosuggestions.zsh

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
