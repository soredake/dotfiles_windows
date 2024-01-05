#!/bin/bash
sudo apt update
# TODO: do i need this?
# sudo sed -i -e "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" -e "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf # https://stackoverflow.com/a/73397970 https://askubuntu.com/a/1424249
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip pipx fish openvpn proxychains4 jq openjdk-11-jre
mkdir -p ~/.local/bin
pipx ensurepath
# TODO: wait for the new version
pipx install tubeup
pipx install https://github.com/gdamdam/iagitup/archive/refs/heads/v1.7.zip
pipx install git+https://github.com/jjjake/internetarchive
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher pure-fish/pure"
wget -4 -N -O ~/.config/fish/config.fish https://raw.githubusercontent.com/soredake/dotfiles_linux/fedora/home/fish/.config/fish/config.fish
# no cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
tee ~/.config/fish/conf.d/config.fish >/dev/null <<EOF
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path \$HOME/.local/bin
alias upall 'sudo apt update; sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y; pipx upgrade-all; brew update && brew upgrade && brew cleanup'
echo -en "\e[6 q"
EOF
grep -q "exec fish" ~/.bashrc || echo "exec fish" >>~/.bashrc
# https://github.com/gdamdam/iagitup/issues/23
mkdir ~/.ia
ln -sfv ~/.config/internetarchive/ia.ini ~/.config/ia.ini
ln -sfv ~/.config/internetarchive/ia.ini ~/.ia/ia.ini
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install lychee
