#!/bin/bash

# Função para exibir mensagens de erro
function error_exit {
    echo "Erro: $1"
    exit 1
}

# Solicita o nome da imagem e a tag ao usuário
read -p "Digite o nome da imagem: " image_name
read -p "Digite a tag da imagem: " image_tag

# Constrói a imagem com Buildah
buildah build -t ${image_name}:${image_tag} . || error_exit "Falha ao construir a imagem"

# Realiza login no Docker Hub com Podman
podman login || error_exit "Falha ao realizar login no Docker Hub"

# Solicita o caminho para o certificado
read -p "Digite o caminho para o certificado de criptografia (ex: certs/esolvere_public.pem): " cert_path
# Solicita o repositório e a tag para enviar
read -p "Digite o repositório para enviar (ex: esolverehub/prototipo): " repo_name
read -p "Digite a tag para a imagem no repositório (ex: latest): " repo_tag

# Criptografa e envia a imagem com Buildah
buildah push --encryption-key jwe:${cert_path} ${repo_name}:${repo_tag} && \
echo "Imagem enviada com sucesso."

# Pergunta se o usuário deseja assinar a imagem
read -p "Você deseja assinar a imagem? (sim/não): " sign_choice

if [ "$sign_choice" == "sim" ]; then
    # Realiza o logout do Docker Hub com Podman
    podman logout || error_exit "Falha ao realizar logout do Docker Hub"

    # Solicita o endereço da imagem no Docker Hub para pull
    read -p "Digite o endereço completo da imagem no Docker Hub (ex: esolverehub/prototipo:latest): " dockerhub_image

    # Solicita o caminho para o certificado de decodificação
    read -p "Digite o caminho para o certificado de decodificação (ex: certs/esolvere_private.pem): " decrypt_cert_path

    # Faz o pull da imagem criptografada usando Buildah
    buildah pull --decryption-key ${decrypt_cert_path} ${dockerhub_image} || error_exit "Falha ao puxar a imagem"

    # Realiza o login no Docker Hub com Docker
    docker login || error_exit "Falha ao realizar login no Docker Hub pelo Docker"

    # Solicita o caminho para a chave de assinatura do Cosign
    read -p "Digite o caminho para a chave de assinatura do Cosign (ex: certs/cosign.key): " cosign_key_path

    # Assina a imagem usando Cosign
    cosign sign -key ${cosign_key_path} ${dockerhub_image} || error_exit "Falha ao assinar a imagem"

    echo "Imagem assinada com sucesso."
else
    echo "Imagem não assinada."
fi
