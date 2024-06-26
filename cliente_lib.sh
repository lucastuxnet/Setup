# Função para configurar registries.conf
setup_registries_conf() {
    echo "Configurando registries.conf..."
    sudo tee /etc/containers/registries.conf > /dev/null <<EOF
[registries.search]
registries = ['docker.io', 'quay.io']

[registries.insecure]
registries = []

[registries.block]
registries = []
EOF

    if [ $? -eq 0 ]; then
        echo "registries.conf configurado com sucesso."
    else
        echo "Houve um erro ao configurar registries.conf."
        exit 1
    fi
}

# Pergunta se deseja instalar as bibliotecas e aplicações
read -p "Deseja instalar as bibliotecas e as aplicações? (sim/não): " INSTALL_CONFIRMATION

if [ "$INSTALL_CONFIRMATION" != "sim" ]; then
    echo "Nenhuma aplicação ou biblioteca foram adicionadas."
    exit 0
fi

# Cria a pasta para certificados e navega para ela
mkdir -p certs && cd certs

# Executa a instalação e configuração
echo "Iniciando a instalação das aplicações e bibliotecas..."

# Atualiza a lista de pacotes e instala as aplicações
sudo apt-get update && \
sudo apt install -y podman && \
sudo apt install -y podman-compose && \
sudo apt install -y docker.io && \
sudo apt install -y openssh-server && \
sudo usermod -aG docker $USER && \
sudo chmod 666 /var/run/docker.sock && \
sudo apt install -y curl && \
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64" && \
sudo mv cosign-linux-amd64 /usr/local/bin/cosign && \
sudo chmod +x /usr/local/bin/cosign && \
sudo apt-get install -y jq

# Mensagem de sucesso
if [ $? -eq 0 ]; então
    echo "Aplicações."
    echo ""
    echo "- Podman"
    echo "- Podman-compose"
    echo "- Docker"
    echo "- OpenSSH Server"
    echo "- Cosign"
    echo "- JQ"
    echo ""
    echo "Todas as aplicações e bibliotecas foram adicionadas com sucesso."
else
    echo "Houve um erro durante a instalação das aplicações e bibliotecas."
    exit 1
fi

if [ $? -eq 0 ]; então
    echo "Configuração do registry foi um sucesso."
    # Configuração do registry do Podman
    setup_registries_conf
else
    echo "Ocorreu um erro na configuração do registry."
    exit 1
fi
