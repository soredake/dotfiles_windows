# NOTE: `wsl` step can run topgrade in WSL
trakts stop
topgrade --no-retry --cleanup --yes --only 'powershell' 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey'
trakts start --restart
psc update *
# scoop cannot upgrade topgrade while it was running
# TODO: move topgrade to winget to fix this once this https://github.com/topgrade-rs/topgrade/issues/958 is fixed
scoop update topgrade
