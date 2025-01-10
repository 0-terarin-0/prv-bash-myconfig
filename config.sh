#!/bin/bash

# Install ZSH
echo "Install ZSH"
(
required=(zsh curl wget git gh)
pm=(brew apt yum port pacman)

for r in ${required[@]}; do
  if ! type ${r} >/dev/null 2>&1; then
    for p in ${pm[@]}; do
      if type ${p} >/dev/null 2>&1; then
        echo "Not installed ${r}, will be installed."
        yes | sudo ${p} install ${r}
        break
      fi
    done
  fi
  if ! type ${r} >/dev/null 2>&1; then
    echo "Error: Required ${r}"
    exit 1
  fi
done
)
# Install Oh-My-Zsh
echo "Install Oh-My-ZSH"
(
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
)

# Install zsh-autosuggestion
echo "Install zsh-autosuggestion"
(
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
)

# Install rustup
echo "Setup rustup"
(
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo 1
# Setup alacritty
echo "Setup Alacritty"
git clone https://github.com/alacritty/alacritty.git
cd alacritty
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
)

# get zshtheme
cd ~/.oh-my-zsh/themes
wget https://raw.githubusercontent.com/0-terarin-0/prv-myconfig/refs/heads/main/mytheme.zsh-theme

# Set .zshrc
cd ~ ;rm -R ~/.zshrc
cat <<EOF >> .zshrc
# Setting of Oh-My-ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="mytheme"
plugins=(
git
zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# Other Settings
fpath+=${ZDOTDIR:-~}/.zsh_functions
EOF

#Reload
exec $SHELL -l
