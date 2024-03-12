# Requires 
# curl, stow, git, zsh tmux, neovim

dependencies=(curl stow git zsh tmux )
if [ -x "$(command -v apt)" ]; then
    sudo apt update
    sudo apt install ${dependencies[@]}
elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Syu
    sudo pacman -S ${dependencies[@]}
elif [ -x "$(command -v brew)" ]; then
    brew install ${dependencies[@]}
else
    echo "No package manager found"
    exit 1
fi


# Prompt to install nvim
if [ -x "$(command -v nvim)" ]; then
    echo "Neovim is already installed"
else
    # if x64 install from github
    if [ "$(uname -m)" == "x86_64" ]; then
        echo "Installing neovim for x86_64"
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage
        rm ./nvim.appimage
    else
      echo "Neovim is not installed please install for your system"
    fi
fi

echo "Cloning submodules"
git submodule init
git submodule update

echo "Installing starship"

# Install starship prompt
curl -sS https://starship.rs/install.sh | sh

echo "Stowing dotfiles"
stow zsh
stow tmux
stow nvim
starship
echo "Done"
