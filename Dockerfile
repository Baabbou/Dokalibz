FROM debian:12.8

WORKDIR /opt

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo curl wget iproute2 nano git zip unzip tldr dnsutils zsh xxd file \
    python3-venv python3-pip python-is-python3 python3-flask python3-aiohttp \
    openssl build-essential iputils-ping arp-scan netcat-openbsd fzf ftp default-mysql-client \
    nmap hashcat pipx ldap-utils

# setup user
RUN useradd --groups 'sudo' --create-home --shell '/usr/bin/zsh' doka && \
    echo 'doka:doka' | chpasswd
COPY zshrc /home/doka/.zshrc

# seclists
# RUN wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O SecList.zip && unzip SecList.zip && rm -f SecList.zip

# go
RUN wget https://go.dev/dl/go1.23.3.linux-amd64.tar.gz -O /tmp/go1.23.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.23.3.linux-amd64.tar.gz

# go install
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
    GOBIN=/opt/go/bin CGO_ENABLED=1 /usr/local/go/bin/go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    # cvemap
    GOBIN=/opt/go/bin /usr/local/go/bin/go install github.com/projectdiscovery/cvemap/cmd/vulnx@latest && \
    # tlsx
    GOBIN=/opt/go/bin /usr/local/go/bin/go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest

RUN mkdir -p /home/doka/.local/bin

# psudohash
RUN git clone https://github.com/t3l3machus/psudohash.git && chmod +x /opt/psudohash/psudohash.py && \
    ln -s /opt/psudohash/psudohash.py /home/doka/.local/bin

# jwtool
RUN git clone https://github.com/ticarpi/jwt_tool.git && python -m venv /opt/jwt_tool/.venv && \
    /opt/jwt_tool/.venv/bin/pip install -r /opt/jwt_tool/requirements.txt && \
    echo 'alias jwtool="/opt/jwt_tool/.venv/bin/python3 /opt/jwt_tool/jwt_tool.py"' >> "/home/doka/.zshrc"

# hexhttp
RUN git clone https://github.com/c0dejump/HExHTTP.git && python -m venv /opt/HExHTTP/.venv && \
    /opt/HExHTTP/.venv/bin/pip install /opt/HExHTTP && \
    echo 'alias hexhttp="/opt/HExHTTP/.venv/bin/python3 /opt/HExHTTP/hexhttp.py"' >> "/home/doka/.zshrc"

# rce
RUN git clone https://github.com/Baabbou/rce.git && echo 'alias rce="sudo -E /opt/rce/rce"' >> "/home/doka/.zshrc"

# rustscan
RUN wget -O /tmp/rustscan.deb.zip https://github.com/bee-san/RustScan/releases/download/2.4.1/rustscan.deb.zip && \
    unzip -d /tmp/rustscan /tmp/rustscan.deb.zip && \
    apt install /tmp/rustscan/rustscan_2.4.1-1_amd64.deb

# nbtscan
RUN wget http://unixwiz.net/tools/nbtscan-1.0.35-redhat-linux -O /home/doka/.local/bin/nbtscan && chmod +x /home/doka/.local/bin/nbtscan

# krbrelayx
RUN git clone https://github.com/dirkjanm/krbrelayx.git && chmod +x /opt/krbrelayx/*.py && \
    echo 'export PATH="$PATH:/opt/krbrelayx/"' >> "/home/doka/.zshrc"

# oke
RUN git clone https://github.com/Baabbou/oke.git && python -m venv /opt/oke/.venv && \
    /opt/oke/.venv/bin/pip install -r /opt/oke/requirements.txt && \
    echo 'alias oke="/opt/oke/.venv/bin/python3 /opt/oke/oke.py"' >> "/home/doka/.zshrc"

RUN chown -R doka:doka /opt /home/doka

# swicth user
USER doka

# pip tools
RUN pip install pypykatz netifaces pycryptodome --break-system-packages
RUN pipx ensurepath
RUN pipx install git+https://github.com/Pennyw0rth/NetExec && \
    pipx install git+https://github.com/fortra/impacket && \
    pipx install git+https://github.com/login-securite/lsassy && \
    pipx install git+https://github.com/brightio/penelope

# setup zsh
RUN echo -y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

WORKDIR /home/doka
RUN mkdir -p /home/doka/.local/share && tldr -u && mv /home/doka/.zshrc.pre-oh-my-zsh /home/doka/.zshrc
    
CMD ["/usr/bin/zsh"]
