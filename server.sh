#!/bin/bash

# Nome do arquivo .pem e tempo em segundos
KEY_FILE="certs/esolvere_private.pem"
TIME_LIMIT=300  # Por exemplo, 300 segundos (5 minutos)
NGINX_PORT=8080
USERNAME="usuario"
PASSWORD="senha"

# Pasta temporária para servir a chave
TMP_DIR="/tmp/nginx-certs"
AUTH_FILE="$TMP_DIR/.htpasswd"

# Função para limpar recursos
cleanup() {
    echo "Limpando recursos..."
    podman container rm -f nginx-temp-container
    podman volume rm nginx-temp-volume
    rm -rf "$TMP_DIR"
    echo "Recursos limpos."
}

# Configuração de sinal para limpeza quando o script for interrompido
trap cleanup EXIT

# Criar pasta temporária
mkdir -p "$TMP_DIR"

# Copiar a chave para a pasta temporária
cp "$KEY_FILE" "$TMP_DIR/"

# Criar arquivo de autenticação
htpasswd -bc "$AUTH_FILE" "$USERNAME" "$PASSWORD"

# Criar volume podman para compartilhar a pasta com Nginx
podman volume create nginx-temp-volume

# Copiar arquivos para o volume
podman run --rm -v nginx-temp-volume:/usr/share/nginx/html alpine cp -r "$TMP_DIR/." /usr/share/nginx/html

# Criar e rodar o container Nginx
podman run -d --name nginx-temp-container \
    -p "$NGINX_PORT:80" \
    -v nginx-temp-volume:/usr/share/nginx/html \
    -v "$AUTH_FILE":/etc/nginx/.htpasswd:ro \
    nginx sh -c 'echo "server { listen 80; location / { auth_basic \"Protected Area\"; auth_basic_user_file /etc/nginx/.htpasswd; } }" > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"'

# Exibir o endereço de download
IP=$(hostname -I | awk '{print $1}')
DOWNLOAD_URL="http://$IP:$NGINX_PORT/$(basename $KEY_FILE)"
echo "Arquivo disponível para download em: $DOWNLOAD_URL"

# Esperar o tempo definido
sleep "$TIME_LIMIT"

# Limpar recursos
cleanup

echo "O arquivo não está mais disponível para download."