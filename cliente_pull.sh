#!/bin/bash

# Solicitar ao usuário o endereço da imagem
read -p "Por favor, insira o endereço da imagem (exemplo: docker.io/esolverehub/image:teste): " image_address

# Caminho para a chave de descriptografia
key_path="certs/esolvere_private.pem"

# Verificar se a chave de descriptografia existe
if [[ ! -f "$key_path" ]]; then
    echo "Chave de descriptografia não encontrada em $key_path."
    exit 1
fi

# Executar o pull da imagem usando buildah
buildah pull --decryption-key "$key_path" "$image_address"
if [[ $? -ne 0 ]]; then
    echo "Erro ao puxar a imagem $image_address."
    exit 1
fi

# Confirmar que o pull foi concluído com sucesso
echo "O pull da imagem $image_address foi concluído com sucesso."

# Remover o arquivo de chave de descriptografia
rm -f "$key_path"
if [[ $? -ne 0 ]]; then
    echo "Erro ao remover a chave de descriptografia $key_path."
    exit 1
fi

# Confirmar que a chave foi removida e o processo está concluído
echo "A chave de descriptografia $key_path foi removida com sucesso."
echo "O processo de subir a imagem foi concluído com sucesso."
