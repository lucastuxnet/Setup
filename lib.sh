#!/bin/bash

# Pergunta se deseja instalar as bibliotecas e aplicações
read -p "Deseja instalar as bibliotecas e as aplicações? (sim/não): " INSTALL_CONFIRMATION

if [ "$INSTALL_CONFIRMATION" != "sim" ]; then
    echo "Nenhuma aplicação ou biblioteca foram adicionadas."
    exit 0
fi

# Executa a instalação e configuração
echo "Iniciando a instalação das aplicações e bibliotecas..."

# Atualiza a lista de pacotes e instala as aplicações
sudo apt-get update && \
sudo apt install -y podman && \
sudo apt install -y podman-compose && \
sudo apt install -y docker.io && \
sudo usermod -aG docker $USER && \
sudo chmod 666 /var/run/docker.sock && \
sudo apt install -y curl && \
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64" && \
sudo mv cosign-linux-amd64 /usr/local/bin/cosign && \
sudo chmod +x /usr/local/bin/cosign && \
sudo apt-get install -y jq

# Mensagem de sucesso
if [ $? -eq 0 ]; then
    echo "Aplicações."
    echo ""
    echo "- Podman"
    echo "- Podman-compose"
    echo "- Docker"
    echo "- Cosign"
    echo "- Pip"
    echo "- JQ"
    echo ""
    echo "Todas as aplicações e bibliotecas foram adicionadas com sucesso."
else
    echo "Houve um erro durante a instalação das aplicações e bibliotecas."
    exit 1
fi

# Pergunta se deseja criar as chaves de segurança
read -p "Você quer criar as chaves de segurança? (sim/não): " KEYS_CONFIRMATION

if [ "$KEYS_CONFIRMATION" != "sim" ]; then
    echo "Chaves de segurança não foram criadas."
    exit 0
fi

# Cria a pasta para certificados e navega para ela
mkdir -p certs && cd certs

# Gera as chaves de segurança
cosign generate-key-pair && \
podman run -it -v $PWD:/work:z docker.io/library/nginx openssl genrsa -out /work/esolvere_private.pem && \
podman run -it -v $PWD:/work:z docker.io/library/nginx openssl rsa -in /work/esolvere_private.pem -pubout -out /work/esolvere_public.pem && \
podman stop $(podman ps -a -q) & podman rm -f $(podman ps -a -q) && podman rmi -f $(podman images -a -q) 

if [ $? -eq 0 ]; then
    echo "Chaves de segurança criadas com sucesso."
else
    echo "Houve um erro ao criar as chaves de segurança."
    exit 1
fi
