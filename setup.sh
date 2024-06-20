#!/bin/bash

# Criar pasta e navegar para ela
mkdir -p images
cd images

# Instalar Docker
sudo apt update
sudo apt install -y docker.io

# Adicionar o usuário ao grupo docker
sudo usermod -aG docker $USER

# Ajustar permissões do Docker
sudo chmod 666 /var/run/docker.sock

# Instalar Podman
sudo apt install -y podman

# Instalar Curl
sudo apt install curl

# Baixar e configurar cosign
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign

# Instalar jq
sudo apt-get install -y jq

# Criar pasta para certificados e navegar para ela
mkdir -p certs
cd certs

# Gerar par de chaves com cosign
cosign generate-key-pair

# Gerar chaves RSA usando Podman e Nginx
podman run -it -v $PWD:/work:z docker.io/library/nginx openssl genrsa -out /work/esolvere_private.pem
podman run -it -v $PWD:/work:z docker.io/library/nginx openssl rsa -in /work/esolvere_private.pem -pubout -out /work/esolvere_public.pem

echo "Script concluído com sucesso!"

