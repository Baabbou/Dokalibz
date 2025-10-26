# Dockalibz

Docker image that contains everytools needed for Pentest

# Run it

```bash
git clone https://github.com/Baabbou/Dokalibz.git
cd Dokalibz
docker build -t dokalibz .
docker run --rm -it -v "$PWD:/host" --name dokalibz dokalibz:latest

# To add an alias
echo alias doka='docker run --rm -it -v "$PWD:/home/doka/host" --name dokalibz dokalibz:latest >> ~/.bashrc
```

# Contact

*Nope ( ͡° ͜ʖ ͡°)*
