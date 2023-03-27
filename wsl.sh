#!/bin/bash
sudo apt update
# sudo add-apt-repository -y ppa:fish-shell/release-3
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf # https://stackoverflow.com/questions/73397110/how-to-stop-ubuntu-pop-up-daemons-using-outdated-libraries-when-using-apt-to-i
sudo apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip python3-venv pipx fish
mkdir -p ~/.local/bin
pipx install tubeup
pipx install iagitup
pipx install internetarchive
pipx ensurepath
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher pure-fish/pure"
sudo chsh -s /usr/bin/fish "$USER"
wget -N -O ~/.config/fish/config.fish https://raw.githubusercontent.com/soredake/dotfiles_linux/fedora/home/fish/.config/fish/config.fish
echo -e "fish_add_path $HOME/.local/bin \nalias upall 'sudo apt update; sudo apt upgrade -y; pipx upgrade-all'" >>~/.config/fish/config.fish
echo 'echo -en "\e[6 q"' >>~/.config/fish/config.fish # no cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
sudo snap set system refresh.retain=2
# https://github.com/flatpak/flatpak/issues/4484 https://github.com/flatpak/flatpak/issues/2267
#sudo rm -rf /dev/shm; sudo mkdir /dev/shm
