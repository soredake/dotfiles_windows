#alias e 'code'
alias exip 'curl -s https://ipecho.net/plain'
alias g 'git'
alias iaupload 'ia upload --checksum --verify --retries 10 -H x-archive-keep-old-version:0' # TODO: replace x-archive-keep-old-version with --no-backup after upgrading to 21.04
#alias nvmestats 'sudo smartctl -A /dev/nvme0'
alias vts 'echo vitetris --connect (exip):27015 && vitetris -listen 27015'
