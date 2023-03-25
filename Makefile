PYTHON_VERSION := $(shell python --version | cut -d " " -f 2 | cut -d "." -f 1-2)
VIRTUAL_ENV_NAME := $(shell basename $$(pwd))_env
PIP_TOOLS_OPTS=--resolver=backtracking --no-header --annotation-style=line
AIRFLOW_HOME := $(shell echo $(HOME)/.airflow)
AIRFLOW_VERSION=2.5.2
CONSTRAINT_URL := https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt


init:
	rm -rf $(VIRTUAL_ENV_NAME)
	mkdir -p $(AIRFLOW_HOME)
	pyenv local $(PYTHON_VERSION)
	touch requirements.txt dev-requirements.txt
	pip install -U pip virtualenv && \
		python -m venv $(VIRTUAL_ENV_NAME) && \
		source $(VIRTUAL_ENV_NAME)/bin/activate && \
		pip install -U pip pip-tools && \
		pip-sync requirements.txt dev-requirements.txt && \
		echo "Run 'source $(VIRTUAL_ENV_NAME)/bin/activate' to activate the generated virtual environment."

install_airflow:
	export AIRFLOW_HOME=$(AIRFLOW_HOME)
	pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
	airflow version

compile:
	pip-compile $(PIP_TOOLS_OPTS) requirements.in
	pip-compile $(PIP_TOOLS_OPTS) dev-requirements.in

sync:
	pip-sync requirements.txt dev-requirements.txt

