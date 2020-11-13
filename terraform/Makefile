.ONESHELL:
.SHELL := /usr/bin/bash
RANDOM := $(shell bash -c 'echo $$RANDOM')
CREDENTIALS := $(shell cat ./credentials)
ENV?=dev

all:
	@if make plan; then \
  		if make apply; then \
  		  	echo "Command succeeded"; \
		  	exit 0; \
  		else \
  			echo "Command failed"; \
		 	exit 1; \
  		fi \
	else \
	  	if make workspace && make apply ; then \
			echo "Command succeeded"; \
	  else \
	  		echo "something went wrong"; \
	  fi \
  	fi

init:
	@echo "Initializating Terraform"
	@$(CREDENTIALS) && terraform init -backend-config=./dev.backend.tfvars

workspace: init
	@echo "Configuring back end"
	@$(CREDENTIALS) && (terraform workspace new ${ENV} && terraform workspace select ${ENV}) || terraform workspace select ${ENV}

fmt:
	@echo "Formating files"
	@terraform fmt -recursive

plan: fmt
	@echo "Planing terraform modification"
	@$(CREDENTIALS) && terraform plan

apply:
	@echo "Applying modification"
	@$(CREDENTIALS) && terraform apply

destroy:
	@if $(CREDENTIALS) && terraform destroy; then \
		echo "Deleted devops"; \
		exit 0; \
  	else \
		if make workspace; then \
			echo "Workspace Initialized"; \
			if terraform destroy -auto-approve; then \
				echo "Deleted devops"; \
				exit 0; \
			else \
			  	echo "Something went worg check up"; \
			  	exit 1; \
			fi \
		fi \
  	fi

clear:
	@rm plan || echo 'no plan remain'
	@echo "all clean up"


.PHONY: clear all
