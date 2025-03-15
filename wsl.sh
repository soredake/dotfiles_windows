#!/bin/bash
# Disable pop-up "Daemons using outdated libraries" by telling needrestart to automatically restart services https://stackoverflow.com/a/73397970
# Disable "Pending kernel upgrade" message https://askubuntu.com/a/1424249
sudo sed -i -e "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" -e "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

# I need newer version https://unix.stackexchange.com/a/740124
# https://github.com/fish-shell/fish-shell/blob/bfb32cdbd94644f29a8e4dd156a50e32e4f4c7c2/CHANGELOG.rst#notable-backwards-incompatible-changes
sudo add-apt-repository -yn ppa:fish-shell/release-4
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
#sudo add-apt-repository -yn ppa:kisak/kisak-mesa

# Installing software
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y pipx fish tmux jq htop
curl -fsSL get.docker.com -o "$HOME/get-docker.sh" && sudo sh "$HOME/get-docker.sh"

# Creating bin dir for user binaries
mkdir -p ~/.local/bin

# Installing topgrade
curl -s https://api.github.com/repos/topgrade-rs/topgrade/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64-unknown-linux-gnu.tar.gz\")) | .browser_download_url" | xargs wget
tar -xzf topgrade*.tar.gz -C ~/.local/bin/
rm topgrade*.tar.gz

# Adding pipx bin dir to PATH
pipx ensurepath

# https://unix.stackexchange.com/a/740124
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher pure-fish/pure"
wget -4 -N -O ~/.config/fish/config.fish https://raw.githubusercontent.com/soredake/dotfiles_linux/fedora/home/fish/.config/fish/config.fish

# No cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
tee ~/.config/fish/conf.d/config.fish >/dev/null <<EOF
fish_add_path \$HOME/.local/bin
alias upall 'topgrade --yes --cleanup --only 'system' 'pipx' 'shell' 'self_update''
echo -en "\e[6 q"
EOF

# https://github.com/microsoft/terminal/issues/4973#issue-583421706
tee ~/.tmux.conf >/dev/null <<EOF
set -g mouse on
EOF

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
  # Disable password for the user
  sudo passwd -d ubuntu

  # https://learn.microsoft.com/en-us/windows/wsl/wsl-config
  # https://github.com/microsoft/WSL/issues/10510
  sudo tee /etc/wsl.conf >/dev/null <<EOF
  [boot]
  systemd=true
EOF

  # Set user shell to fish
  sudo chsh -s /usr/bin/fish "$USER"
else
  # https://github.com/canonical/multipass/issues/3033
  grep -q "exec fish" ~/.bashrc || echo "exec fish" >>~/.bashrc
fi
