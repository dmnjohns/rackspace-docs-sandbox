.PHONY: all docs
.SILENT: banner help

# Vars
SHELL             := /bin/bash
VENV              := $WORKSPACE/.venv
VENV_CREATE       := virtualenv $VENV
VENV_ACTIVATE     := source $VENV/bin/activate
PREP              := $(VENV_CREATE) && $(VENV_ACTIVATE)

ifneq ("$(shell which xdg-open)","")
	OPENER := $(shell which xdg-open)
else
	ifneq ("$(shell which open)","")
		OPENER := $(shell which open)
	else
		OPENER = echo "Browse to "
		$(warning The 'open' and 'xdg-open' commands were not found.)
	endif
endif

default: help

banner:
	echo ""
	echo "            r a c k s p a c e              "
	echo ""

help: banner
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lint: ## Run lint tests
	@$(PREP) && tox

test: lint ## Run all tests

setup: ## Setup local environment
	@test -d $(VENV) || virtualenv $(VENV) --no-site-packages
	@./$(VENV)/bin/pip install pip==9.0.1
	@./$(VENV)/bin/pip install -r ./requirements.txt

html: ## Render documentation
	@$(PREP) && cd docs && make html

htmlvers: ## Render documentation
	@$(PREP) && cd docs && make htmlvers

# docs: ## For development purposes, render docs as a single html and open a viewer
# 	@$(PREP) && cd docs && make singlehtml
# 	@${OPENER} docs/_build/singlehtml/index.html
#
freeze: ## Set pins in requirements
	@$(PREP) && pip freeze > requirements.txt
