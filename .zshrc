export LANG=C.UTF-8

export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'
export PATH=$PATH:/usr/local/go/bin:/opt/go/bin:$HOME/.local/bin

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

alias rce="/opt/rce/rce.sh"
alias cupp="/usr/bin/python3 /opt/cupp/cupp.py"
alias jwtool="/opt/jwt_tool/.venv/bin/python3 /opt/jwt_tool/jwt_tool.py"
alias hexhttp="/opt/HExHTTP/.venv/bin/python3 /opt/HExHTTP/hexhttp.py"
alias oke="/opt/oke/.venv/bin/python3 /opt/oke/oke.py"
#### Pentest ####

#### Forensic ####
alias vol="/opt/volatility3/.venv/bin/python3 /opt/volatility3/vol.py"
#### Forensic ####
