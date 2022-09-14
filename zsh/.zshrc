#!/bin/zsh

# Init prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

  # Set theme
  autoload -Uz promptinit
  promptinit
  prompt paradox
fi

autoload -Uz add-zsh-hook

# neofetch
echo -e "\n";neofetch

# Add GOPATH
export GOPATH=$HOME/go
# export GOROOT=/usr/lib/go

# Add PATHs
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.yarn/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH=$GOPATH/bin:$PATH

# Alias
alias L='wc -l'
alias ssh-keygen-tsuyoi='ssh-keygen -t ecdsa -b 521'
alias pubip='curl https://checkip.amazonaws.com/'
alias ngrok-http='ngrok http -region ap'
alias zshrc='nano ~/.zshrc && echo "Press enter reload zsh"; read && exec zsh'

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
  alias yabai='killall plasmashell;kstart plasmashell'
  alias trash-clean='sudo rm -rf ~/.local/share/Trash/files && mkdir ~/.local/share/Trash/files'
fi

# SSH Color
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # __TERMINAL_EMULATOR=`basename "/"$(ps -f -p $(dog /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //')`
  __TERMINAL_EMULATOR=`basename $(ps -p $(ps -p $$ -o ppid=) o args= | cut -d ' ' -f 1)`
  KONSOLE_PROFILE=
  function ssh_color() {
    local CMD=${1}
    local NEXT_PROFILE=

    case "$CMD" in
      ssh*production-* ) {
        NEXT_PROFILE=ArgonautRed
      } ;;

      ssh*staging-* ) {
        NEXT_PROFILE=ArgonautPurple
      } ;;

      ssh*develop-* ) {
        NEXT_PROFILE=ArgonautGreen
      } ;;

      ssh* ) {
        NEXT_PROFILE=ArgonautBlue
      } ;;
    esac

    if [[ "$NEXT_PROFILE" == "" ]]; then {
      NEXT_PROFILE=Argonaut
    } fi

    if [[ ! "$KONSOLE_PROFILE" == "$NEXT_PROFILE" ]]; then {
      KONSOLE_PROFILE=$NEXT_PROFILE
      if [[ "${__TERMINAL_EMULATOR}" == "konsole" ]]; then {
        konsoleprofile colors=$NEXT_PROFILE
      } fi
      if [[ "${__TERMINAL_EMULATOR}" == "dolphin" ]]; then {
        konsoleprofile colors=$NEXT_PROFILE
      } fi
      if [[ "${__TERMINAL_EMULATOR}" == "yakuake" ]]; then {
        konsoleprofile colors=$NEXT_PROFILE
      } fi
    } fi
  }
  add-zsh-hook precmd ssh_color
  add-zsh-hook preexec ssh_color
elif [[ "$OSTYPE" == "darwin"* ]]; then
  function ssh_color() {
    case $1 in
      product-* ) echo -e "\033]50;SetProfile=zsh_red\a" ;;
      staging-* ) echo -e "\033]50;SetProfile=zsh_purple\a" ;;
      develop-* ) echo -e "\033]50;SetProfile=zsh_green\a" ;;
      *) echo -e "\033]50;SetProfile=zsh_blue\a" ;;
    esac
    ssh $@
    # SSHの接続が終わったらもとのプロファイルに戻す
    echo -e "\033]50;SetProfile=zsh\a"
  }
  alias ssh='ssh_color'
  compdef _ssh ssh_color=ssh
elif [[ "$OSTYPE" == "cygwin" ]]; then
  #
elif [[ "$OSTYPE" == "msys" ]]; then
  #
elif [[ "$OSTYPE" == "win32" ]]; then
  #
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  #
else
  echo "wtf!?"
fi

# Load private config
if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.priv" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.priv"
fi
