trakts stop
# 'powershell' 'node' 'scoop' 'chocolatey' moved to unigetui
# uv/pipx: https://github.com/marticliment/UniGetUI/issues/1301 https://github.com/marticliment/UniGetUI/issues/3696
topgrade --no-retry --cleanup --yes --only 'uv'
# uv tool upgrade --all
trakts start --restart
