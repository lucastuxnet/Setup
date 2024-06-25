#!/bin/bash

# Define a função para exibir mensagens e finalizar em caso de erro
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Solicitar o nome e a tag da imagem
read -p "Digite o nome da imagem: " nome_imagem
read -p "Digite a tag da imagem: " tag_imagem

# Construir a imagem com o podman
echo "Construindo a imagem com o podman..."
podman build -t "docker.io/esolverehub/${nome_imagem}:${tag_imagem}" . || error_exit "Erro ao construir a imagem."

# Verificar se a construção foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Imagem construída com sucesso."
else
    error_exit "Erro durante a construção da imagem."
fi

# Salvar o nome da imagem e tag no arquivo JSON
echo "{ \"imagem\": \"${nome_imagem}:${tag_imagem}\" }" > images.JSON || error_exit "Erro ao salvar no arquivo images.JSON."

# Listar todas as imagens para verificação
echo "Verificando as imagens disponíveis:"
podman images

# Perguntar se deseja criptografar e assinar a imagem
read -p "Deseja criptografar e assinar a imagem? (sim/nao): " resposta

if [ "$resposta" != "sim" ]; then
    echo "Script finalizado."
    exit 0
fi

# Conectar ao Docker Hub
echo "Conectando ao Docker Hub com podman..."
podman login || error_exit "Erro ao conectar ao Docker Hub."
echo "Login podman efetuado com sucesso."

# Recuperar o nome da imagem e tag do arquivo JSON
imagem_tag=$(jq -r '.imagem' images.JSON) || error_exit "Erro ao ler o arquivo images.JSON."

# Criptografar e enviar a imagem
echo "Criptografando e enviando a imagem ${imagem_tag}..."
podman push --encryption-key jwe:certs/esolvere_public.pem "docker.io/esolverehub/${imagem_tag}" || error_exit "Erro ao enviar a imagem."
echo "Imagem criptografada com sucesso."

# Conectar ao Docker Hub com Docker CLI
echo "Conectando ao Docker Hub com Docker CLI..."
docker login || error_exit "Erro ao conectar ao Docker Hub com Docker CLI."
echo "Login docker efetuado com sucesso."

# Fazer pull da imagem de docker.io
echo "Fazendo pull da imagem docker.io/esolverehub/${imagem_tag}..."
buildah pull --decryption-key certs/esolvere_private.pem "docker.io/esolverehub/${imagem_tag}" || error_exit "Erro ao fazer pull da imagem."
echo "Pull efetuado com sucesso."

# Assinar a imagem
echo "Assinando a imagem docker.io/esolverehub/${imagem_tag}..."
cosign sign -key certs/cosign.key "docker.io/esolverehub/${imagem_tag}" || error_exit "Erro ao assinar a imagem."
echo "Imagem assinada com sucesso."

# Finalizar o script
echo "Script finalizado."
