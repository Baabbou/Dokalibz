export LANG=C.UTF-8

export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'
export PATH="$PATH:/usr/local/go/bin:/opt/go/bin:/home/doka/.local/bin"

ZSH_THEME="gnzh"
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    sudo
    git)
source $ZSH/oh-my-zsh.sh

alias zshconf="nano ~/.zshrc"

#### Pentest ####
alias wl-all="find /opt/SecLists-master/ -type f | fzf"
alias wl-password="find /opt/SecLists-master/Passwords/ -type f | fzf"
alias wl-web="find /opt/SecLists-master/Discovery/Web-Content/ -type f | fzf"
#### Pentest ####

