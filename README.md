# Gestão de Vulnerabilidades.

O objetivo do script é para o gerenciamento de vulnerabilidades em um servidor.

O script foi desenvolvido com a finalidade de automação de processos via instalar aplicações e bibliotecas em servidores de terceiros, para uma demanda na empresa Esolvere Tecnologia.

O script consistem nos seguintes procedimentos:

- Instalação de aplicação para gestão de containernização
    Podman
    Podman-compose
    Docker
    Openssh-server
    Net-tools
- Instalação de aplicação para geração de assinaturas e verificação de imagens.
    Cosign
- Geração de chaves utilizando a aplicaçao do Cosign e o Openssl via Nginx.
    Cosign
    Nginx
    Openssl
- Instalação do JQ para leitura de assinaturas pelo Cosign.
     JQ

Bibliotecas necessárias para utilizar o script.

PIP

Procedimentos para execução do código.

- Bibliotecas e aplicações.
  
  chmod +x lib.sh
  ./lib.sh

- Assinatura e criptografia de imagem.
  
    chmod +x lib.sh
    ./image.sh

- Bibliotecas e aplicações no servidor cliente.
  
  chmod +x cliente_lib.sh
  ./cliente_lib.sh

- Transferência de chave privada entre local-cliente.
  
  chmod +x scp.sh
  ./scp.sh

- Descriptografia e pull da imagem no servidor cliente.
  
  chmod +x cliente_pull.sh
  ./cliente_pull.sh
