#!/bin/bash

# Ativa o UFW, se não estiver ativado
echo "Ativando o UFW..."
sudo ufw enable

# Permite conexões na porta SSH padrão (22)
echo "Permitindo conexões SSH na porta 22..."
sudo ufw allow ssh

# Exibe o status atual do UFW
echo "Status atual do UFW:"
sudo ufw status verbose

# Testa o serviço SSH
echo "Verificando se o SSH está ativo..."
if sudo systemctl is-active --quiet ssh; then
    echo "SSH está ativo e em execução."
else
    echo "SSH não está ativo. Tente reiniciar o serviço com 'sudo systemctl restart ssh'."
fi

echo "Configuração do UFW e verificação do SSH concluídas."
