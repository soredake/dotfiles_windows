trakts stop
# 'powershell' 'node' 'scoop' 'chocolatey' moved to unigetui
# uv step is broken, wait for >=16.0.5 release
#topgrade --no-retry --cleanup --yes --only 'uv'
uv tool upgrade --all
trakts start --restart
