# Gestão de Vulnerabilidades.

O objetivo do script é para o gerenciamento de vulnerabilidades em um servidor.

O script foi desenvolvido com a finalidade de instalar aplicações e bibliotecas em servidores de terceiros, para uma demanda na empresa Esolvere Tecnologia.

O script consistem nos seguintes procedimentos:

- Instalação de aplicação para gestão de containernização
    Podman
    Docker
- Instalação de aplicação para geração de assinaturas em imagens.
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

chmod +x setup.sh

./setup.sh
