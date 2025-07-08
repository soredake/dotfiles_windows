#!/bin/bash
# I need newer version https://unix.stackexchange.com/a/740124
# https://github.com/fish-shell/fish-shell/blob/bfb32cdbd94644f29a8e4dd156a50e32e4f4c7c2/CHANGELOG.rst#notable-backwards-incompatible-changes
# https://repology.org/project/fish/versions
sudo add-apt-repository -y ppa:fish-shell/release-4

# Installing software
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y pipx fish tmux jq htop

# Creating bin dir for user binaries
mkdir -p ~/.local/bin

# Installing topgrade
curl -s https://api.github.com/repos/topgrade-rs/topgrade/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64-unknown-linux-gnu.tar.gz\")) | .browser_download_url" | xargs wget
tar -xzf topgrade*.tar.gz -C ~/.local/bin/
rm topgrade*.tar.gz

# pipx stuff
pipx ensurepath
pipx install internetarchive

# https://unix.stackexchange.com/a/740124
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher pure-fish/pure"
wget -4 -N -O ~/.config/fish/config.fish https://raw.githubusercontent.com/soredake/dotfiles_linux/refs/heads/kubuntu/home/fish/.config/fish/config.fish

# No cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
tee ~/.config/fish/conf.d/config.fish >/dev/null <<EOF
fish_add_path \$HOME/.local/bin
alias upall 'topgrade --yes --cleanup --only 'system' 'pipx' 'shell' 'self_update''
echo -en "\e[6 q"
EOF

# https://wiki.archlinux.org/title/Tmux#Other_Settings
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
  sudo passwd -d "$USER"

  # https://learn.microsoft.com/en-us/windows/wsl/wsl-config
  sudo tee /etc/wsl.conf >/dev/null <<EOF
  [boot]
  systemd=true
EOF

  # Set user shell to fish
  sudo chsh -s "$(which fish)" "$USER"
else
  # https://github.com/canonical/multipass/issues/3033
  grep -q "exec fish" ~/.bashrc || echo "exec fish" >>~/.bashrc
fi
