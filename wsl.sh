#!/bin/bash
# Disable pop-up "Daemons using outdated libraries" by telling needrestart to automatically restart services https://stackoverflow.com/a/73397970
# Disable "Pending kernel upgrade" message https://askubuntu.com/a/1424249
sudo sed -i -e "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" -e "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

# I need newer version https://unix.stackexchange.com/a/740124
sudo add-apt-repository -yn ppa:fish-shell/release-3
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
sudo add-apt-repository -yn ppa:kisak/kisak-mesa

# Installing software
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip pipx fish tmux jq htop
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
# https://github.com/fish-shell/fish-shell/blob/bfb32cdbd94644f29a8e4dd156a50e32e4f4c7c2/CHANGELOG.rst#notable-backwards-incompatible-changes
fish -c "
    # Download and source fisher.fish
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source;
    # Install fisher and pure prompt
    fisher install jorgebucaran/fisher pure-fish/pure;
    # Enable the 'qmark-noglob' feature globally
    #set -U fish_features qmark-noglob
"
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

# https://github.com/canonical/multipass/issues/3033
grep -q "exec fish" ~/.bashrc || echo "exec fish" >>~/.bashrc

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
  # https://github.com/microsoft/WSL/issues/11261#issuecomment-2478574303
  sudo tee /etc/systemd/user/symlink-wayland-socket.service >/dev/null <<EOF
[Unit]
Description=Symlink Wayland socket to XDG_RUNTIME_DIR

[Service]
Type=oneshot
ExecStart=/usr/bin/ln -s /mnt/wslg/runtime-dir/wayland-0      $XDG_RUNTIME_DIR
ExecStart=/usr/bin/ln -s /mnt/wslg/runtime-dir/wayland-0.lock $XDG_RUNTIME_DIR

[Install]
WantedBy=default.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl enable x11-symlink.service
  sudo systemctl --user enable symlink-wayland-socket.service
fi
