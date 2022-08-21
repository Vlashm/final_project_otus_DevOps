.DEFAULT_GOAL := help
.PHONY: help

USER_NAME?=vlashm

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

build_mongo_image: ## Build mongodb image
	packer build -var-file $(CURDIR)/infra/packer/variables.json $(CURDIR)/infra/packer/main.json