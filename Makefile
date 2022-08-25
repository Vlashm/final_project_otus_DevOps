.DEFAULT_GOAL := help
.PHONY: help

USER_NAME?=vlashm

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

get_gitlab_root_pass: ## Get root pass and runner token for GitLab
	cd ./infra/ansible
	ansible-playbook ./playbooks/get-root-pass.yml
	cd ../..

add_helm_repo: ## Add helm repositorys: ingress-nginx, prometheus-community, gitlab
	helm repo add nginx-stable https://helm.nginx.com/stable
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add gitlab https://charts.gitlab.io
	helm repo update

install_ingress: ## Install nginx-ingress
	helm upgrade --install nginx-ingress nginx-stable/nginx-ingress
	kubectl get svc

get_ingress_ip: ## Get ingress external ip
	kubectl get svc

create_namespace: ## Create namespace: "app", "monitoring", "logging"
	kubectl apply -f ./microservices/namespace.yml

install_app: ## install app
	helm upgrade --install mongodb microservices/Charts/mongodb/
	helm upgrade --install rabbitmq microservices/Charts/rabbitmq/
	helm upgrade --install crawler microservices/Charts/crawler/
	helm upgrade --install ui microservices/Charts/ui/

install_monitoring: ## Install kube-prometheus-stack
	helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
	--namespace monitoring --create-namespace \
	-f ./microservices/Charts/monitoring/values.yaml

install_logging: ## Install loging
	cd ./infra/ansible
	ansible-playbook ./playbooks/elasticsearch-pv.yml
	cd ../..
	kubectl apply -f microservices/logging 

install_runner: ## Install gitlab runner
	helm upgrade --install --namespace default gitlab-runner -f ./infra/gitlab-runner/values.yaml gitlab/gitlab-runner
	kubectl apply -f ./infra/gitlab-runner/gitlab-service-account.yaml
	kubectl -n kube-system get secrets -o json | \
    jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | \
    base64 --decode > token