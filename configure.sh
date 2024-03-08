# Requires 
# curl, stow, git, zsh tmux, neovim

git submodule init
git submodule update

# Install starship prompt
curl -sS https://starship.rs/install.sh | sh

stow zsh
stow tmux
stow nvim
