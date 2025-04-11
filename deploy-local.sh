#!/bin/bash

echo "⌛️ Loading variables from .dev.env..."
if [ -f .dev.env ]; then
  export $(grep -v '^#' .dev.env | xargs)
else
  echo "Error: .dev.env file not found!"
  exit 1
fi

echo "🚀 Starting Minikube..."
minikube start --driver=docker

echo "🔧 Configuring Docker to use Minikube..."
eval $(minikube docker-env)

echo "🐳 Building the Docker image..."
docker build -t petclinic-rest:latest .

echo "🔐 Creating MySQL secret..."
kubectl create secret generic mysql-secret \
  --from-literal=MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  --from-literal=MYSQL_USER=$MYSQL_USER \
  --from-literal=MYSQL_PASSWORD=$MYSQL_PASSWORD \
  --from-literal=MYSQL_DATABASE=$MYSQL_DATABASE

echo "📦 Deploying MySQL resources..."
kubectl apply -f k8s/dev/mysql/

echo "⏳ Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod -l app=petclinic-mysql

echo "🔐 Creating PetClinic secret..."
kubectl create secret generic petclinic-secret \
  --from-literal=SPRING_DATASOURCE_URL=$SPRING_DATASOURCE_URL \
  --from-literal=SPRING_DATASOURCE_USERNAME=$SPRING_DATASOURCE_USERNAME \
  --from-literal=SPRING_DATASOURCE_PASSWORD=$SPRING_DATASOURCE_PASSWORD

echo "🚀 Deploying PetClinic application..."
kubectl apply -f k8s/dev/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "⏳ Waiting for PetClinic to be ready..."
kubectl wait --for=condition=ready pod -l app=petclinic-rest --timeout=120s

echo "🔍 Creating Minikube Tunnel"
minikube tunnel
echo "✅  Tunnel successfully started"

echo "🔍 Getting PetClinic service URL..."
#SERVICE_URL=$(minikube service petclinic-rest --url)
minikube service petclinic-rest --url

echo "✅ Deployment complete!"
#echo "🌍 Access your application at: $SERVICE_URL"

# Keep the script running to maintain resources
read -p "Press any key to delete the deployment and clean up..." -n1 -s


