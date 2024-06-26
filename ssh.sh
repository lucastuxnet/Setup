#!/bin/bash

# Função para exibir uma linha divisória
divider() {
    echo "--------------------------------------------------"
}

# Função para configurar o UFW para permitir SSH
configurar_ufw() {
    echo "Configurando UFW para permitir conexões SSH..."
    sudo ufw enable -y  # Ativa o UFW se não estiver ativo
    sudo ufw allow ssh  # Permite conexões na porta SSH padrão (22)
    echo "UFW configurado para permitir conexões SSH."
    divider
}

# Função para testar o serviço SSH
testar_ssh() {
    echo "Testando o status do serviço SSH..."
    sudo systemctl is-active --quiet ssh && echo "SSH está ativo e em execução." || echo "SSH não está ativo. Verifique o serviço."
    divider
}

# Função principal para executar todas as etapas
main() {
    configurar_ufw
    testar_ssh
    echo "Configuração concluída. Firewall e serviço SSH configurados."
}

# Executa a função principal
main
