# NOTE: `wsl` step can run topgrade in WSL
trakts stop
topgrade --no-retry --cleanup --yes --only 'powershell' 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey'
trakts start --restart
psc update *
# scoop cannot upgrade topgrade while it was running
scoop update topgrade
