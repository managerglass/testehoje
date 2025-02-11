# managerglass-oficial

Sistema de orçamento de manufatura de perfis metálicos.

## Este projeto foi feito com:

* [Python 3.10.4](https://www.python.org/)
* [Django 4.0.7](https://www.djangoproject.com/)
* [Bootstrap 4.0](https://getbootstrap.com/)

## Como rodar o projeto?

* Clone esse repositório.
* Crie um virtualenv com Python 3.
* Ative o virtualenv.
* Instale as dependências.
* Rode as migrações.
* Altere o host da maquina
* Altere o npm run serve do vue

```bash
# Para mudar o host da sua maquina:
# Abra o arquivo hosts em C:\Windows\System32\drivers\etc 
# como administrador no powershell e use o comando
notepad C:\Windows\System32\drivers\etc\hosts
# dentro do notepad voce vai adicionar as seguintes linhas
#  IP-da-sua-maquina    dominio-host
#  IP-da-sua-maquina    subdominio.dominio-host
# exemplo 127.0.0.1    localhost
# exemplo 127.0.0.1    subdominio.localhost

# Para alterar o npm do vuejs:
# Abra o arquivo vue.config.js e adicione
devServer: {
        allowedHosts: 'all', // deixe all para funcionar o multi tenant
        host: 'seu-host-aqui', // substitua pelo host da sua maquina
        port: 8080, // substitua pela porta desejada
    }
    
# Como rodar o servidor Django
git clone https://github.com/managerglass/managerglass-oficial.git
cd managerglass-oficial
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements
python contrib/env_gen.py

python manage.py migrate
python manage.py createsuperuser --email="admin@email.com"
python manage.py test

# Criação de Tenant exemple
python manage.py create_tenant \
 --schema_name='orolglass' \
 --name='orolglass' \
 --on_trial=True \
 --domain-domain='orolglass.localhost' \
 --domain-is_primary=True -s

# OrolGlass Ltda
python manage.py create_tenant \
 --schema_name='orolglass' \
 --name='OrolGlass Ltda' \
 --on_trial=True \
 --domain-domain='orolglass.localhost' \
 --domain-is_primary=True -s

# Manager Glass Ltda
python manage.py create_tenant \
 --schema_name='managerglass' \
 --name='Manager Glass Ltda' \
 --on_trial=True \
 --domain-domain='managerglass.localhost' \
 --domain-is_primary=True -s

python manage.py tenant_command create_data --schema=managerglass
```

## Com Docker

```bash
docker-compose -f docker-compose-django-dev.yml up --build -d
# ou para rodar PostgreSQL no Docker e Django localmente
docker-compose -f docker-compose-dev.yml up --build -d
docker-compose up -d  # produção

docker container exec -it managerglass_app python manage.py migrate

docker container exec -it managerglass_app python manage.py createsuperuser --email="admin@managerglass.com.br"

# Acme Corp
docker container exec -it managerglass_app bash -c \
"python manage.py create_tenant \
 --schema_name='orolglass' \
 --name='orolglass' \
 --on_trial=True \
 --domain-domain='orolglass.localhost' \
 --domain-is_primary=True -s"

# OrolGlass Ltda LOCAL
docker container exec -it managerglass_app bash -c \
"python manage.py create_tenant \
 --schema_name='orolglass' \
 --name='OrolGlass' \
 --on_trial=True \
 --domain-domain='orolglass.localhost' \
 --domain-is_primary=True -s"

# Manager Glass Ltda LOCAL
docker container exec -it managerglass_app bash -c \
"python manage.py create_tenant \
 --schema_name='managerglass' \
 --name='Manager Glass' \
 --on_trial=True \
 --domain-domain='managerglass.localhost' \
 --domain-is_primary=True -s"

# Manager Glass Ltda EM PRODUCAO
docker container exec -it managerglass_app bash -c \
"python manage.py create_tenant \
 --schema_name='managerglass' \
 --name='Manager Glass' \
 --on_trial=True \
 --domain-domain='orolglass.managerglass.com.br' \
 --domain-is_primary=True -s"

docker container exec -it managerglass_app bash -c "python manage.py create_tenant_superuser --email='admin@email.com'"

docker container exec -it managerglass_app bash

docker container logs -f managerglass_app
```

## Usando Django e PostgreSQL no Docker em ambiente de desenvolvimento

```bash
docker-compose -f docker-compose-django-dev2.yml up --build -d
docker container exec -it managerglass_app python manage.py migrate
docker container exec -it managerglass_app python manage.py createsuperuser --email="admin@admin.com.br"
docker container exec -it managerglass_app bash -c \
"python manage.py create_tenant \
 --schema_name='orolglass' \
 --name='OrolGlass' \
 --on_trial=True \
 --domain-domain='orolglass.localhost' \
 --domain-is_primary=True -s"
```

## Erro UserProfile

Corrigindo o erro `RelatedObjectDoesNotExist at /admin/login/ User has no profile`

```bash
python manage.py tenant_command shell_plus --schema=managerglass
```

```python
user = User.objects.get(email='admin@email.com')
UserProfile.objects.create(user=user)
```

```bash
# Orolglass
python manage.py tenant_command shell_plus --schema=orolglass
```

```python
user = User.objects.get(email='admin@email.com')
UserProfile.objects.create(user=user)
```

## ASW S3

Crie buckets com nome

```
<SCHEMA_NAME>-media
```

Exemplo:

```
orolglass-media
managerglass-media
orolglass-media
```

### Imagens

Deve-se usar `{{ imagem.url|replace_url }}` nas imagens de **media**.

```
{% load replace_url_tags %}
<img src="{{ request.user.userprofile.imagem.url|replace_url }}">
```
#   t e s t e g p t  
 #   t e s t e g p t  
 #   t e s t e h o j e  
 