### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
declare -A ZINIT
ZINIT[COMPINIT_OPTS]=-C
grep -q 'OMZ::plugins' $HOME/.zinit/bin/zinit.zsh && sed -i 's/OMZ::plugins/OMZplugins/g' $HOME/.zinit/bin/zinit.zsh
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### End of Zinit's installer chunk
# TODO: shell cannot start/slow downs while starting sometimes
#if [[ -f /usr/share/zsh/functions/Completion/Unix/_npm ]]; then
#  [[ ! -f $HOME/.npm-completion ]] && npm completion > $HOME/.npm-completion
#  rm /usr/share/zsh/functions/Completion/Unix/_npm
#fi
#source $HOME/.npm-completion
#zinit snippet OMZP::yarn
#zinit snippet OMZP::bower
#zinit light BuonOmo/yarn-completion
#zinit light zsh-users/zsh-completions
#zinit light zdharma-continuum/fast-syntax-highlighting
# TODO: this slows down shell startup: chrisands/zsh-yarn-completions
zinit for \
  light-mode zsh-users/zsh-autosuggestions zsh-users/zsh-completions \
  light-mode pick"async.zsh" src"pure.zsh" sindresorhus/pure

zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/grep.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

# https://github.com/zdharma-continuum/zinit#calling-compinit-without-turbo-mode
# https://unix.stackexchange.com/a/178054
#unsetopt complete_aliases
autoload -Uz compinit
compinit
zinit cdreplay -q

# https://github.com/msys2/MSYS2-packages/issues/38#issuecomment-148653609
zstyle ':completion:*' fake-files /: '/:c f e'
# https://blog.vghaisas.com/zsh-beep-sound/
unsetopt LIST_BEEP
# https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557
[[ -v WT_SESSION ]] && echo -en "\e[2 q"

alias e='code'
#alias exip='curl -s https://ipecho.net/plain'
#alias g='git'
alias iaupload='ia upload --checksum --verify --retries 10 -H x-archive-keep-old-version:0'
#alias vts='vitetris -listen 27015'

#[[ ! -f $HOME/.npm-completion ]] && npm completion > $HOME/.npm-completion
#source $HOME/.npm-completion
