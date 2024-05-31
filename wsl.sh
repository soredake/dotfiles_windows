#!/bin/bash
# I need newer version https://unix.stackexchange.com/a/740124
sudo add-apt-repository -yn ppa:fish-shell/release-3
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
sudo add-apt-repository -yn ppa:kisak/kisak-mesa
sudo apt update
# https://stackoverflow.com/a/73397970 https://askubuntu.com/a/1424249
sudo sed -i -e "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" -e "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip pipx fish openvpn tmux speedtest-cli jq
curl -fsSL get.docker.com -o get-docker.sh && sudo sh get-docker.sh
mkdir -p ~/.local/bin

# Installing topgrade
curl -s https://api.github.com/repos/topgrade-rs/topgrade/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64-unknown-linux-gnu.tar.gz\")) | .browser_download_url" | xargs wget
tar -xzf topgrade*.tar.gz -C ~/.local/bin/
rm topgrade*.tar.gz

pipx ensurepath
# NOTE: Combine this after updating to >=24.04
pipx install tubeup
pipx install https://github.com/gdamdam/iagitup/archive/refs/heads/v1.7.zip
pipx install internetarchive

# https://unix.stackexchange.com/a/740124
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher pure-fish/pure; set -U fish_features qmark-noglob"
wget -4 -N -O ~/.config/fish/config.fish https://raw.githubusercontent.com/soredake/dotfiles_linux/fedora/home/fish/.config/fish/config.fish

# No cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
tee ~/.config/fish/conf.d/config.fish >/dev/null <<EOF
#eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fish_add_path \$HOME/.local/bin
#alias upall 'sudo apt update; sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y; pipx upgrade-all; brew update && brew upgrade && brew cleanup'
function clean-snaps
  LANG=C snap list --all | while read snapname ver rev trk pub notes
    if string match -q "*disabled*" $notes
      sudo snap remove "$snapname" --revision="$rev"
    end
  end
end
alias upall 'topgrade --yes --cleanup --only 'system' 'pipx' 'shell' 'self_update'; clean-snaps'
echo -en "\e[6 q"
EOF

# https://github.com/microsoft/terminal/issues/4973#issue-583421706
tee ~/.tmux.conf >/dev/null <<EOF
set -g mouse on
EOF

# https://github.com/canonical/multipass/issues/3033
grep -q "exec fish" ~/.bashrc || echo "exec fish" >>~/.bashrc

# https://github.com/gdamdam/iagitup/issues/23
mkdir ~/.ia
ln -sfv ~/.config/internetarchive/ia.ini ~/.config/ia.ini
ln -sfv ~/.config/internetarchive/ia.ini ~/.ia/ia.ini

# curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# brew install lychee

# https://wiki.archlinux.org/title/Systemd/Journal#Journal_size_limit
# https://github.com/systemd/systemd/issues/17382
sudo mkdir -p /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/00-journal-size.conf >/dev/null <<EOF
[Journal]
SystemMaxUse=200M
EOF
sudo systemctl daemon-reload

# https://github.com/microsoft/WSL/issues/4071
if grep -q microsoft /proc/version; then
  # https://github.com/microsoft/WSL/issues/1278#issuecomment-1377893172
  sudo systemctl enable /usr/share/systemd/tmp.mount

  # https://github.com/microsoft/wslg/issues/1156#issuecomment-1876266025
  sudo tee /etc/systemd/system/x11-symlink.service >/dev/null <<EOF
[Unit]
Description=Setup X11 Symlink

[Service]
Type=oneshot
ExecStartPre=/bin/rm -rf /tmp/.X11-unix
ExecStart=/bin/ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix

[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl enable x11-symlink.service
fi
