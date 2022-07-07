# Apache Airflow

Airflow is a platform to programmatically author, schedule and monitor workflows.

Use Airflow to author workflows as Directed Acyclic Graphs (DAGs) of tasks.
The Airflow scheduler executes your tasks on an array of workers while following the specified dependencies.
Rich command line utilities make performing complex surgeries on DAGs a snap.
The rich user interface makes it easy to visualize pipelines running in production, monitor progress, and troubleshoot issues when needed.

## Getting started

To create a new Airflow instance, follow the steps below:

1.  Create a new repository from the `SFI-Airflow-template` [template repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template).
2.  Add all secrets listed below (see Github secrets).
3.  [Manually](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow) run the Github workflow `deploy-db` to deploy the MySQL database:

![](images/run_workflow_manually.png)

4.  Repeat the third step, but run the Github workflow `init-db` to initialize the MySQL database.
5.  Either push a change to the repository, or [`Re-run all jobs`](https://docs.github.com/en/actions/managing-workflow-runs/re-running-workflows-and-jobs#re-running-all-the-jobs-in-a-workflow) on the last commit to trigger the QA workflow.
    This will deploy the Airflow scheduler, webserver, etc.

## Deployment

What pods does this template encompass?

*   `apache-airflow-airflow`.
    Apache Airflow main instance.

    *   `scheduler`.
        Celery task queue.
    *   `webserver`.
        UI.
    *   `flower`.
        Celery UI.
    *   `triggerer`.
        Asynchronous executor.

*   `apache-airflow-redis`.
    Redis database.
*   `apache-airflow-mysql`.
    MySQL database.
    Locally, set `AIRFLOW__DATABASE__SQL_ALCHEMY_CONN`, and initialize via `make mysql-init`.
    Remotely, use the container deployed as `apache-airflow-initdb`.
    The database credentials are `airflow:airflow`; the database name is `airflow`.
    The UI credentials are `admin:MJ`.
*   `apache-airflow-worker`.
    Celery workers.
    The Celery task queue scales horizontally with the number of replica.

## Environment variables

*   `AIRFLOW__CELERY__BROKER_URL`.
    For instance, `redis://apache-airflow-redis:6379/0`.
*   `AIRFLOW__CELERY__RESULT_BACKEND`.
    For instance, `db+mysql+pymysql://airflow:airflow@apache-airflow-mysql:3306/airflow`.
*   `AIRFLOW__CORE__EXECUTOR`.
    For instance, `CeleryExecutor`.
*   `AIRFLOW__CORE__HOSTNAME`.
    For instance, `airflow.utils.net.get_host_ip_address`.
*   `AIRFLOW__DATABASE__SQL_ALCHEMY_CONN`.
    For instance, `mysql+pymysql://airflow:airflow@apache-airflow-mysql:3306/airflow`.
*   `AIRFLOW__WEBSERVER__SECRET_KEY`.

## GitHub secrets

To create an Airflow instance from this template, recreate the [Github secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) in your own repository:

1.  Application secrets:

    *   `APP_NAME`.
        Application name, e.g. `apache-airflow`.

2.  Artifactory secrets:

    *   `ARTIFACTORY_HOST`.
        Artifactory registry, e.g. `gfbb-powertaindata-docker-local.artifactory.ber02.tzla.net`.
    *   `ARTIFACTORY_USERNAME`.
        Artifactory user, e.g. `hansyu`.
    *   `ARTIFACTORY_PASSWORD`.
        Artifactory password.

3.  Kubernetes configuration.

    *   `KUBE_CLUSTER`.
        Kubernetes cluster, e.g. `eu-ber02-prd-factory`.
    *   `KUBE_NAMESPACE`.
        Kubernetes namespace, e.g. `hansyu`.
    *   `KUBE_TOKEN`.
        Bearer token; taken from Fuze service account.
        A new Fuze JWT [Tokens can be created in Fuze](https://console.platform.tesla.com/account/tokens).
        Create a `NEW USER SERIVCE IDENTITY`, copy the token and store it securely.
        This Token is only displayed once!

4.  Airflow configuration.

    *   `AIRFLOW_USER`.
        User name.
    *   `AIRFLOW_PASS`.
        Password.
    *   `AIRFLOW_FIRST`.
        First name.
    *   `AIRFLOW_LAST`.
        Last name.
    *   `AIRFLOW_EMAIL`.
        Email address.
