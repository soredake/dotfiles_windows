# NOTE: `wsl` step can run topgrade in WSL
trakts stop
topgrade --no-retry --cleanup --yes --only 'powershell' 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey'
trakts start --restart
psc update *
# https://github.com/topgrade-rs/topgrade/issues/891
# TODO: implemented in https://github.com/topgrade-rs/topgrade/pull/909, wait for the new version
scoop cache rm -a
