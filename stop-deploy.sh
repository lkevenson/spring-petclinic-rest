#!/bin/bash

echo "❌ delete all resources"
kubectl delete all --all



echo "❌ delete mysql secret"
kubectl delete secret mysql-secret

echo "❌ delete petclinic secret"
kubectl delete secret petclinic-secret

echo "❌ delete mysql pvc"
kubectl delete pvc mysql-pvc

#echo "❌ Delete your entire Minikube cluste"
#minikube delete

echo "❌ Stop minikube"
minikube stop


#chmod +x stop-deploy.sh


# value inside mysql-secret
#kubectl get secret mysql-secret -o yaml


#To get more information about why the container
# kubectl logs pod-name


#minikube service petclinic-mysql --url
# kubectl describe pod pod-name
#kubectl logs pod-name

#kubectl get deploy petclinic-rest -o yaml


# kubectl get all -n default
