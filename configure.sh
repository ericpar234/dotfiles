# Requires 
# curl, stow, git, zsh tmux, neovim

git submodule init
git submodule update

#curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
#chmod u+x nvim.appimage
#./nvim.appimage
#rm ./nvim.appimage

# Install starship prompt
curl -sS https://starship.rs/install.sh | sh

stow zsh
stow tmux
stow nvim
