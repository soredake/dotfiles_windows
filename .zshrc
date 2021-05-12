### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
#declare -A ZINIT
#ZINIT[COMPINIT_OPTS]=-C
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

if [[ -f /usr/share/zsh/functions/Completion/Unix/_npm ]]; then
  [[ ! -f $HOME/.npm-completion ]] && npm completion > $HOME/.npm-completion
  rm /usr/share/zsh/functions/Completion/Unix/_npm
fi
source $HOME/.npm-completion

zinit light zsh-users/zsh-autosuggestions
#zinit light zsh-users/zsh-completions
zinit light chrisands/zsh-yarn-completions
#zinit light BuonOmo/yarn-completion
zinit snippet OMZ::lib/clipboard.zsh
#zinit snippet OMZP::yarn
zinit snippet OMZP::bower
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/grep.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure


# https://github.com/zdharma/zinit#calling-compinit-without-turbo-mode
# https://unix.stackexchange.com/a/178054
#unsetopt complete_aliases
autoload -Uz compinit
compinit
zinit cdreplay -q

# https://github.com/msys2/MSYS2-packages/issues/38#issuecomment-148653609
zstyle ':completion:*' fake-files /: '/:c'
