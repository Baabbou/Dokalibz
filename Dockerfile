FROM debian:13.4

WORKDIR /opt

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo curl wget iproute2 nano git zip unzip dnsutils zsh xxd file \
    python3-venv python3-pip python-is-python3 pipx samba libkrb5-dev openssl build-essential \
    iputils-ping arp-scan netcat-openbsd fzf ftp default-mysql-client nmap hashcat proxychains4 \
    ldap-utils krb5-user tesseract-ocr libreoffice tesseract-ocr-eng tesseract-ocr-osd && \
    rm -rf /var/lib/apt/lists/*

# setup user
RUN useradd --create-home --shell '/usr/bin/zsh' doka && \
    echo 'doka:doka' | chpasswd && \
    echo 'doka ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo 'Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin::/usr/local/go/bin:/opt/go/bin:/home/doka/.local/bin"' >> /etc/sudoers
COPY zshrc /home/doka/zshrc

# seclists
# RUN wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O SecList.zip && unzip SecList.zip && rm -f SecList.zip

# go
RUN wget https://go.dev/dl/go1.26.1.linux-amd64.tar.gz -O /tmp/go1.26.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.26.1.linux-amd64.tar.gz

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
    echo 'alias psudohash.py="cd /opt/psudohash/ && python3 psudohash.py"' >> /home/doka/zshrc

# jwtool
RUN git clone https://github.com/ticarpi/jwt_tool.git && python -m venv /opt/jwt_tool/.venv && \
    /opt/jwt_tool/.venv/bin/pip install -r /opt/jwt_tool/requirements.txt && \
    echo 'alias jwtool="/opt/jwt_tool/.venv/bin/python3 /opt/jwt_tool/jwt_tool.py"' >> /home/doka/zshrc

# hexhttp
RUN git clone https://github.com/c0dejump/HExHTTP.git && python -m venv /opt/HExHTTP/.venv && \
    /opt/HExHTTP/.venv/bin/pip install /opt/HExHTTP && \
    echo 'alias hexhttp="/opt/HExHTTP/.venv/bin/python3 /opt/HExHTTP/hexhttp.py"' >> /home/doka/zshrc

# rce
RUN git clone https://github.com/Baabbou/rce.git && echo 'alias rce="sudo -E /opt/rce/rce"' >> /home/doka/zshrc

# nbtscan
RUN wget http://unixwiz.net/tools/nbtscan-1.0.35-redhat-linux -O /home/doka/.local/bin/nbtscan && chmod +x /home/doka/.local/bin/nbtscan

# krbrelayx
RUN git clone https://github.com/dirkjanm/krbrelayx.git && chmod +x /opt/krbrelayx/*.py && \
    echo 'export PATH="$PATH:/opt/krbrelayx/"' >> /home/doka/zshrc

# oke
RUN git clone https://github.com/Baabbou/oke.git && python -m venv /opt/oke/.venv && \
    /opt/oke/.venv/bin/pip install -r /opt/oke/requirements.txt && \
    echo 'alias oke="/opt/oke/.venv/bin/python3 /opt/oke/oke.py"' >> /home/doka/zshrc

# spray sh
RUN wget https://raw.githubusercontent.com/Greenwolf/Spray/refs/heads/master/spray.sh -O /home/doka/.local/bin/spray.sh && \
    chmod +x /home/doka/.local/bin/spray.sh

RUN chown -R doka:doka /opt /home/doka

# swicth user
USER doka

# pip tools
RUN pip install netifaces pycryptodome --break-system-packages

RUN pipx ensurepath --global
RUN pipx install git+https://github.com/Pennyw0rth/NetExec && \
    pipx install git+https://github.com/fortra/impacket && \
    pipx install git+https://github.com/blacklanternsecurity/MANSPIDER && \
    pipx install git+https://github.com/login-securite/lsassy && \
    pipx install git+https://github.com/dirkjanm/BloodHound.py && \
    pipx install git+https://github.com/synacktiv/gpoParser && \
    pipx install git+https://github.com/CravateRouge/bloodyAD && \
    pipx install git+https://github.com/franc-pentest/ldeep && \
    pipx install git+https://github.com/lgandx/Responder && \
    pipx install git+https://github.com/skelsec/pypykatz && \
    pipx install git+https://github.com/brightio/penelope && \
    pipx install git+https://github.com/tldr-pages/tldr-python-client

# setup zsh
RUN echo -y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

WORKDIR /home/doka
COPY --chown=doka:doka zsh_history /home/doka/.zsh_history
RUN mv /home/doka/zshrc /home/doka/.zshrc

CMD ["/usr/bin/zsh"]
