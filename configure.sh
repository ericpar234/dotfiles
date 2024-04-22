#!/bin/bash
# Requires 
# curl, stow, git, zsh tmux, neovim

dependencies=(curl stow git zsh tmux ripgrep)
for dep in ${dependencies[@]}; do
    if [ -x "$(command -v $dep)" ]; then
        echo "$dep is already installed"
    else
        echo "$dep is not installed"
        missing_dependencies+=($dep)
    fi
done
for dep in ${missing_dependencies[@]}; do
    echo "Installing $dep"
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
done

# Prompt to install nvim
if [ -x "$(command -v nvim)" ]; then
    echo "Neovim is already installed"
else
    # if x64 install from github
    if [ "$(uname -m)" == "x86_64" ]; then
        echo "Installing neovim for x86_64"
        curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
        tar -xf nvim-linux64.tar.gz
        cp -r nvim-linux64/* ~/.local
        rm -rf nvim-linux64
        rm nvim-linux64.tar.gz
        echo "Done installing neovim"
    else
      echo "Neovim is not installed please install for your system"
    fi
fi

echo "Cloning submodules"
git submodule init
git submodule update

echo "Installing starship"
# Install starship prompt
if [ -x "$(command -v starship)" ]; then
    echo "Starship is already installed"
else
    echo "Installing starship"
    curl -sS https://starship.rs/install.sh | sh
fi

# Install nerd font
font_name="MartianMono"
font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.tar.xz"

mkdir "./tmp"
echo $font_url
echo curl -OL $font_url
curl -OL $font_url
echo "extract the $font_name.tar.xz"
tar -xf $font_name.tar.xz -C ./tmp
mkdir -p ~/.local/share/fonts
cp -r ./tmp/*.ttf ~/.local/share/fonts
fc-cache -fv
rm -rf ./tmp
rm "$font_name.tar.xz"
echo "Done installing $font_name"     

echo "Stowing dotfiles"
stow zsh --restow
stow tmux --restow
stow nvim --restow
stow starship --restow
echo "Done with stow"

echo "Setting zsh as default shell"
chsh -s $(which zsh)
