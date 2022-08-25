# Проектная работа: Создание процесса непрерывной поставки для приложения с применением Практик CI/CD и быстрой обратной связью 

## Необходимые локальные инструменты

- Рабочая станция с ОС *Ubuntu*
- Yandex CLI
- Ansible
- Terraform
- Kubectl
- helm

## Внешние ресурсы

- Yandex Cloud
- Доменное имя с прописанными DNS-серверами: `ns1.yandexcloud.net и ns2.yandexcloud.net`

## Запуск проекта

### Создание инфраструктуры

В дирректории *infra/terraform* создать файл *terraform.tfvars* со своими значениями, используя как шаблон файл *terraform.tfvars.example*. Затем в корневой директории проекта выполнить команду:

        terraform init
        terraform apply

В результате *terraform* создаст:
- Сеть, подсеть и DNS зону
- Виртуальную машину *GitLab* и создаст запись в *DNS cloud* для *gitlab*
- Кластер *Kubernetes* с тремя нодами
- Три диска *yandex compute disk* для *Elasticsearch* и файл переменных *штакф/ansible/values/elasticsearch_id_file.yml* с их id
- Настроит контекст *kubectl*

В корневой директории выполнить команду `make install_ingress` для установки ingress контроллера

В дирректории *infra/terraform/dns* выполнить команды:

        terraform init
        terraform apply

В результате *terraform* cоздаст записb в *DNS cloud*:
- *app.<ваш_домен>* - для приложения
- *prometheus.<ваш_домен>* - для *prometheus*
- *grafana.<ваш_домен>* - для *grafana*
- *kibana.<ваш_домен>* - для *kibana*

### Ansible

В дирректории *infra/ansible* выполнить команды:

        ansible-playbook playbooks/elasticsearch-pv.yml 
        ansible-playbook playbooks/install-docker.yml
        ansible-playbook playbooks/install-gitlab.yml
        ansible-playbook playbooks/start-runer.yml

*Ansible* создаст три *PersistentVolume* для *Elasticsearch* и установит *gitlab* на ранее созданную ВМ. 

## Микросервисы

В корневой директории выполнить команду `make create_namespace` для создания пространств имён.

### Приложение

Для поднятия приложения в корневой директории выполнить команду `make install_app`. В кластере *Kubernetes* будут подняты:

- rabbitmq
- mongodb
- crawler
- crawler-ui

Приложение будет доступно по адресу *app.<ваш_домен>*

### Monitoring

Для поднятия сервисов мониторинга в корневой директории  выполнить команды `make install_monitoring`. будут установлены:

- Prometheus
- Grafana

*Prometheus* будет доступен по адресу *prometheus.<ваш_домен>*
*Grafana* будет доступна по адресу *grafana.<ваш_домен>*

### Logging

Для поднятия сервисов ljubhjdfybz в корневой директории  выполнить команды `make install_logging`

*Kibana* будет доступна по адресу *kibana.<ваш_домен>*

### Gitlab CI/CD

- Для получения пароля *root* и токена для *gitlab-runner* выполнить команду `make get_gitlab_root_pass`
- Для установки *gitlab-runner* в файле *infra/gitlab-runner/values.yaml* указать свой *URL* и токен, полученный предыдущей командой
- Зайти на *gitlab.<ваш_домен>*, используя полученный *root* пароль, создать группу *crawler* и проект *crawler*

В CI/CD реализованы следующие этапы (stages):

- test - тестирование приложения
- build - сборка приложения
- review - обзор и проверка приложения
- release - отправка образов на Docker Hub
- deploy - развертывание приложения