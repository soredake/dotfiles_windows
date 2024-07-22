# NOTE: `wsl` step can run topgrade in WSL
trakts stop
topgrade --no-retry --cleanup --yes --only 'powershell' 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey'
trakts start --restart
scoop cache rm -a
