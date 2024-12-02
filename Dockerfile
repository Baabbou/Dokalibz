FROM debian:12.8

WORKDIR /opt

RUN apt-get update && apt-get upgrade 
RUN apt-get install -y sudo curl wget iproute2 nano git zip unzip tldr dnsutils zsh xxd file \
    python3-venv python3-pip python-is-python3 python3-flask python3-aiohttp \
    openssl build-essential iputils-ping arp-scan netcat-openbsd fzf ftp

# go
RUN wget https://go.dev/dl/go1.23.3.linux-amd64.tar.gz -O /tmp/go1.23.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.23.3.linux-amd64.tar.gz

# oke
RUN git clone https://github.com/Baabbou/oke.git && python -m venv ./oke/.venv && \
    ./oke/.venv/bin/pip install -r ./oke/requirements.txt

#### Pentest ####
RUN apt-get install -y nmap hashcat

# seclists
RUN wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O SecList.zip && unzip SecList.zip && rm -f SecList.zip

RUN mkdir -p /opt/go/bin && \
    # dnsx
    GOBIN=/opt/go/bin /usr/local/go/bin/go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    # subfinder
    GOBIN=/opt/go/bin /usr/local/go/bin/go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    # httpx
    GOBIN=/opt/go/bin /usr/local/go/bin/go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    # ffuf
    GOBIN=/opt/go/bin /usr/local/go/bin/go install github.com/ffuf/ffuf/v2@latest && \
    # katana
    GOBIN=/opt/go/bin CGO_ENABLED=1 /usr/local/go/bin/go install github.com/projectdiscovery/katana/cmd/katana@latest

    # cupp
RUN git clone https://github.com/Mebus/cupp.git && \
    # jwtool
    git clone https://github.com/ticarpi/jwt_tool.git && python -m venv ./jwt_tool/.venv && \
    ./jwt_tool/.venv/bin/pip install -r ./jwt_tool/requirements.txt && \
    # hexhttp
    git clone https://github.com/c0dejump/HExHTTP.git && python -m venv ./HExHTTP/.venv && \
    ./HExHTTP/.venv/bin/pip install -r ./HExHTTP/requirements.txt && \
    # rce
    git clone https://github.com/Baabbou/rce.git    
#### Pentest ####


#### Active Directory ####
# responder
# impacket
# gpp_decrypt

#### Active Directory ####


#### Forensic ####
# volatility
# binwalk
# foremost
# 7z
#### Forensic ####


# setup user
RUN useradd --groups 'sudo' --create-home --shell '/usr/bin/zsh' babbz-doka && chown -R babbz-doka:babbz-doka /opt
RUN echo 'babbz-doka:babbz' | chpasswd
USER babbz-doka



# setup zsh
RUN echo -y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

COPY .zshrc /home/babbz-doka/.zshrc

WORKDIR /home/babbz-doka
RUN mkdir -p ~/.local/share && tldr -u

CMD ["/usr/bin/zsh"]
