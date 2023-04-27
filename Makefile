PYTHON_VERSION := 3.10.10
SHORT_PYTHON_VERSION := $(shell echo $(PYTHON_VERSION) | egrep -io '\d+\.\d+')
project_home := $(shell pwd)
virtualenv_name := $(shell basename $(project_home))_env
AIRFLOW_VERSION := 2.5.3
CONSTRAINT_URL := https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${SHORT_PYTHON_VERSION}.txt
AIRFLOW_HOME := ~/airflow
PIPTOOLS_OPTS := --annotation-style=line --no-header --resolver=backtracking --upgrade

apache_airflow_config:
	mkdir -p $(AIRFLOW_HOME)
	export AIRFLOW_HOME=$(AIRFLOW_HOME)
	export SQLALCHEMY_SILENCE_UBER_WARNING=1
	@echo "- I you haven't already, put the following 2 lines to the bottom of your requirements.in file:\n"
	@echo "apache-airflow==$(AIRFLOW_VERSION)"
	@echo "-c $(CONSTRAINT_URL)\n"

init:
	@rm -rf $(virtualenv_name)
	@pyenv local $(PYTHON_VERSION)
	@touch requirements.txt requirements.in dev-requirements.txt dev-requirements.in
	@pip install -U pip virtualenv
	@virtualenv $(virtualenv_name) && \
		source $(virtualenv_name)/bin/activate && \
		pip install -U pip pip-tools
	@echo "You can now activate your virtual environment using the following command:"
	@echo "\tsource $(virtualenv_name)/bin/activate"

compile:
	pip-compile $(PIPTOOLS_OPTS) requirements.in 
	pip-compile $(PIPTOOLS_OPTS) dev-requirements.in

sync:
	pip-sync requirements.txt dev-requirements.txt

