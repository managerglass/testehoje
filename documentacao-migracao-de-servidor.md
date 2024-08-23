# Documentação Iniciar Servidor

> Aqui está um guia passo a passo para iniciar um servidor do zero em uma VPS ou servidor Linux na nuvem, seja para migração ou criação.
> 

1. Configurar o acesso root pela plataforma (hostinger)
    1.  Acessar o painel de visão geral
    2. Navegue para Acesso SSH
    3. altere a senha do usuario root
2. Acessar terminal servidor pelo “linux” ou “Putty”
3. Atualizar o ambiente linux instalado
    1. sudo apt-get upgrade
4. Instalar dependências para rodar o servidor
    1. git
    2. python
    3. nginx
    4. postgresql
5. Criar um repositório com uma virtualenv do python
6. Clonar o repositório do projeto para o repositório no servidor
7. Instalar as dependências do python e do vuejs3
8. Configurar o .env do backend para configurações da aws e banco de dados
9. Configuração do postgresql:
    1. verificar o status do postgres → `sudo systemctl status postgresql`
    2. verificar se o postgres esta aceitando conexao → `sudo pg_isready`
    3. conectar ao postgresql → `sudo -u postgres psql`
    4. alterar senha do usuario → `ALTER USER postgres PASSWORD 'NovaSenha';`
    5. crie o banco de dados com o nome que foi usado para o backend
10. configurar arquivo postgresql.conf no caminho `etc/postgresql/<versao-do-postgres>/main`
    1. descer até as configurações de conexao e colocar o listen_addresses para ouvir em ‘*’
11. configurar arquivo pg_hba.conf no caminho /etc/postgresql/<versao do postgres>/main
    1. descer ate configuracao de IPv4 local e deixar o address para “0.0.0.0/0” e o method em “md5”
12. reiniciar o postgres com o comando → sudo systemctl restart postgresql
13. Configurar acesso do banco de dados do servidor no pgadmin
    1. abrir pgadmin 
    2. registrar um novo acesso a um servidor
    3. adicionar o nome que voce preferir
    4. na aba de “connection” adicione
        - host name → ip do servidor
        - maintenance database → colocar nome do banco de dados do backend
        - password → colocar a senha que foi alterada do usuario do postgres
14. configurar o gunicorn
    1. navegar até a pasta que foi clonada do github 
    2. verificar se realmente foi instalado o gunicorn
    3. adicionar a porta 8000 na lista de portas permitidas → sudo ufw allow 8000
    4. iniciar o gunicorn → gunicorn —bind ip_do_servidor:8000 nome_do_projeto.wsgi
    5. configurar o gunicorn.service no caminho /etc/systemd/system
    adicionat as seguintes configurações no arquivo:
    [Unit]
    Description = gunicorn daemon
    After = network.target
    
    [Service]
    User=root
    Group=www-data
    WorkingDirectory=/caminho/pro/repositorio
    ExecStart=/caminho/para/virtualenv/do/repositorio —access-logfile - —workers 3 —bind endereco_de_ip:8000 backend.wsgi:application
    
    [Install]
    WantedBy=multi-user.target
    6. reiniciar o daemon do gunicorn → sudo systemctl daemon-reload
    7. reiniciar o gunicorn → sudo systemctl restart gunicorn
15. configuraçao do nginx
    1. navegue até /etc/nginx/sites-available
    2. remova todos os arquivos e crie um default
    3. dentro desse arquivo adicione as seguintes confiugrações:
    server {
    listen 80;
    
    location / {
                  proxy_pass http://ip_do_servidor:8000;
    
    }
    
    location /static {
                  autoindex off;
                  alias /caminho/pros/arquivos/estaticos/;
    }
    
    location /media {
                  alias /caminho/para/arquivos/media/;
    }
    
    }
    4. remova o arquivo que estiver no caminho /etc/nginx/sites-enable
    5. teste a configuração com o comando → nginx -t
    6. restart o servidor nginx → sudo systemctl restart nginx
    7. verifique o status com o comando → sudo systemctl status nginx