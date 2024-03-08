# Set up the prompt

source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
## tab into autocomplete menu
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

fpath=(~/.config/zsh/zsh-completions/src $fpath)

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

if command -v zoxide > /dev/null; then
   eval "$(zoxide init zsh)"
 fi
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

bindkey -e

#EDITOR
export EDITOR=nvim
export VISUAL=nvim

if command -v batcat > /dev/null; then
   alias cat=batcat
fi
if command -v lsd > /dev/null; then
   alias ls=lsd
fi

#starship
eval "$(starship init zsh)"

bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
