from datetime import datetime

from airflow import DAG

with DAG(dag_id='user_processing', start_date=datetime(2022, 1, 1),
         schedule_interval='@daily', catchup=False) as dag:
    None
