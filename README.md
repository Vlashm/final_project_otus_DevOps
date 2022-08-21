# Проектная работа: Создание процесса непрерывной поставки для приложения с применением Практик CI/CD и быстрой обратной связью

В процессе: создание *CI/CD* на базе *GitLab*, подключение оповещений, мелкие доработки уже существующего кода и исправление возможных ошибок  

## Необходимые локальные инструменты

- Рабочая станция с ОС *Ubuntu*
- Yandex CLI
- Ansible
- Terraform
- Kubectl

## Внешние ресурсы

- Yandex Cloud
- Доменное имя с прописанными DNS-серверами: `ns1.yandexcloud.net и ns2.yandexcloud.net`

## Запуск проекта

### Terraform

В дирректории *infra/terraform* создать файл *terraform.tfvars* со своими значениями, используя как шаблон файл *terraform.tfvars.example*. Затем выполнить команды:

        terraform init
        terraform apply

В результате *terraform* создаст:
- Сеть, подсеть и DNS зону
- Виртуальную машину для *GitLab* и создаст запись в *DNS cloud* для *gitlab*
- Кластер *Kubernetes* с тремя нодами
- Три диска *yandex compute disk* для *Elasticsearch* и файл переменных *штакф/ansible/values/elasticsearch_id_file.yml* с их id
- Настроит контекст *kubectl*
- Произведет установку *ingress*

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

В директории *microservices* выполнить команду `kubectl apply -f namespace.yml` для создания пространств имён

### Приложение

Для поднятия приложения в директории *microservices* выполнить команды: 

        kubectl apply -f app/rabbitmq
        kubectl apply -f app/mongo
        kubectl apply -f app/crawler

Приложение будкт доступно по адресу *app.<ваш_домен>*

### Monitoring

Для поднятия сервисов мониторинга в директории *microservices* выполнить команды: 

        kubectl apply -f monitorimg/prometheus
        kubectl apply -f monitoring/grafana

*Prometheus* будет доступен по адресу *prometheus.<ваш_домен>*
*Grafana* будет доступна по адресу *grafana.<ваш_домен>*

### Logging

Для поднятия сервисов сбора логов в директории *microservices* выполнить команды: 

        kubectl apply -f logging

*Kibana* будет доступна по адресу *kibana.<ваш_домен>*

### Gitlab CI/CD