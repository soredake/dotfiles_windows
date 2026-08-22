trakts stop
# 'powershell' 'node' 'scoop' 'chocolatey' moved to unigetui
# uv/pipx: https://github.com/Devolutions/UniGetUI/issues/1301 https://github.com/Devolutions/UniGetUI/issues/3696
topgrade --no-retry --cleanup --yes --only 'uv'
# uv tool upgrade --all
trakts start --restart

# Clean 0install cache, it is not cleared automatically and can grow significantly over time
# https://docs.0install.net/details/cache/#windows
0install update-all --clean
