APP_NAME = apache-airflow
ARTIFACTORY_HOST = gfbb-powertaindata-docker-local.artifactory.ber02.tzla.net

.PHONY: image
image: Dockerfile
	docker build -t $(APP_NAME) .

.PHONY: publish
publish: image
	docker tag $(APP_NAME) $(ARTIFACTORY_HOST)/$(APP_NAME)
	docker push $(ARTIFACTORY_HOST)/$(APP_NAME)

.PHONY: deployment
deployment: image templates.minikube.d/airflow.d/
	kubectl apply -f templates.minikube.d/airflow.d/

.PHONY: rollout
rollout: deployment
	kubectl rollout restart deployment $(APP_NAME)-containerized

.PHONY: secret
secret:
	kubectl create --dry-run=client -o yaml --save-config=true secret generic $(APP_NAME)-env --from-env-file=.env | kubectl apply -f -

.PHONY: mysql
mysql: templates.minikube.d/mysql.d
	kubectl apply -f templates.minikube.d/mysql.d/

# Set `AIRFLOW__DATABASE__SQL_ALCHEMY_CONN`.
.PHONY: mysql-init
mysql-init:
	airflow db init
	airflow users create --username admin --password MJ --firstname Peter --lastname Parker --role Admin --email spiderman@superhero.org

.PHONY: redis
redis: templates.minikube.d/redis.d/
	kubectl apply -f templates.minikube.d/redis.d/

.PHONY: worker
worker: templates.minikube.d/worker.d/
	kubectl apply -f templates.minikube.d/worker.d/
