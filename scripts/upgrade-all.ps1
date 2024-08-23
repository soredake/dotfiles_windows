# NOTE: `wsl` step can run topgrade in WSL
trakts stop
topgrade --no-retry --cleanup --yes --only 'powershell' 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey'
trakts start --restart
# https://github.com/topgrade-rs/topgrade/issues/891
scoop cache rm -a
