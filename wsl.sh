#!/bin/bash
sudo add-apt-repository -y ppa:fish-shell/release-3 # i need newer version https://unix.stackexchange.com/a/740124
# sudo apt update
sudo sed -i -e "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" -e "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf # https://stackoverflow.com/a/73397970 https://askubuntu.com/a/1424249
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip pipx fish openvpn tmux docker.io docker-compose speedtest-cli # proxychains4 jq
mkdir -p ~/.local/bin
# TODO: request update https://pacstall.dev/packages/topgrade-bin
curl -s https://api.github.com/repos/topgrade-rs/topgrade/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64-unknown-linux-gnu.tar.gz\")) | .browser_download_url" | xargs wget
tar -xzf topgrade*.tar.gz -C ~/.local/bin/
rm topgrade*.tar.gz
pipx ensurepath
# TODO: wait for the new version to arrive in repos and combine this
pipx install tubeup
pipx install https://github.com/gdamdam/iagitup/archive/refs/heads/v1.7.zip
pipx install git+https://github.com/jjjake/internetarchive
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher pure-fish/pure; set -U fish_features qmark-noglob" #  https://unix.stackexchange.com/a/740124
wget -4 -N -O ~/.config/fish/config.fish https://raw.githubusercontent.com/soredake/dotfiles_linux/fedora/home/fish/.config/fish/config.fish
# no cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
tee ~/.config/fish/conf.d/config.fish >/dev/null <<EOF
#eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path \$HOME/.local/bin
#alias upall 'sudo apt update; sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y; pipx upgrade-all; brew update && brew upgrade && brew cleanup'
alias upall 'topgrade --yes --cleanup --only 'system' 'pipx' 'shell' 'self_update''
echo -en "\e[6 q"
EOF
# https://github.com/microsoft/terminal/issues/4973#issue-583421706
tee ~/.tmux.conf >/dev/null <<EOF
set -g mouse on
EOF
grep -q "exec fish" ~/.bashrc || echo "exec fish" >>~/.bashrc
# https://github.com/gdamdam/iagitup/issues/23
mkdir ~/.ia
ln -sfv ~/.config/internetarchive/ia.ini ~/.config/ia.ini
ln -sfv ~/.config/internetarchive/ia.ini ~/.ia/ia.ini
# curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# brew install lychee
# https://github.com/microsoft/WSL/issues/1278#issuecomment-1377893172
sudo systemctl enable /usr/share/systemd/tmp.mount
