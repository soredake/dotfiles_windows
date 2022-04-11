#!/bin/bash
#sudo apt update
sudo add-apt-repository -y ppa:fish-shell/release-3
sudo apt upgrade -y
sudo apt install -y python3-pip pipx fish
pipx install tubeup internetarchive
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher pure-fish/pure"
chsh -s /usr/bin/fish
wget -O "$HOME/.config/fish/config.fish" https://github.com/soredake/dotfiles_home/raw/kubuntu/home/fish/.config/fish/config.fish
echo "fish_add_path $HOME/.local/bin" >> ~/.config/fish/config.fish
echo "alias upall 'sudo apt update; sudo apt upgrade -y; pipx upgrade-all'" >> ~/.config/fish/config.fish
# https://github.com/bibanon/tubeup/issues/172
mkdir "$HOME/.ia"
ln -sfv "$HOME/.config/internetarchive/ia.ini" "$HOME/.config/ia.ini"
ln -sfv "$HOME/.config/internetarchive/ia.ini" "$HOME/.ia/ia.ini"
