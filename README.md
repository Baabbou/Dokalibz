# Dockalibz

Docker image that contains everytools needed for Pentest

# Run it

```bash
git clone https://github.com/Baabbou/Dokalibz.git
cd Dokalibz
docker build -t dokalibz .
docker run --rm -it -v "$PWD:/host" --name dokalibz dokalibz:latest
```

To lauch it directly from terminal, add this to your `bashrc` :

```bash
function doka {
    docker ps -f 'name = dokalibz' | grep 'Up' >/dev/null
    if [[ "$?" == "0" ]]; then
        docker exec -u doka -it dokalibz /usr/bin/zsh
    else
        docker run --rm --name dokalibz --net=host --cap-add=NET_RAW --cap-add=NET_ADMIN -it -v "/home/tklingler/Documents/Cyber:/home/doka/cyber" -v "$PWD:/home/doka/host" dokalibz:latest
    fi
}
```

# Contact

*Nope ( ͡° ͜ʖ ͡°)*
