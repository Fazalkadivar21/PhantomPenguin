#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Git
sudo apt-get install -y git

git config --global user.email "fazalkadivar21@gmail.com"
git config --global user.name "fazalkadivar21"

# Install Zsh
sudo apt install -y zsh

sudo apt install curl

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source $(pwd)/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Clone zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Apply Starship preset
starship preset gruvbox-rainbow -o ~/.config/starship.toml
