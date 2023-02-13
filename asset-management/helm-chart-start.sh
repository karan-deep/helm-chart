#!/bin/bash

minikube version > /dev/null 2>&1 || {
echo "Please install minikube https://minikube.sigs.k8s.io/docs/start/" 
exit 
};

hyperkit -v > /dev/null 2>&1 || { 
echo "Please install hyperkit https://minikube.sigs.k8s.io/docs/drivers/hyperkit/"
exit 
};

helm version > /dev/null 2>&1 || { 
echo "Please install helm https://helm.sh/docs/intro/install/"
exit 
};

# making hyperkit the default driver for minikube
if [[ $(minikube config get driver) != 'hyperkit' ]]
	then
		minikube config set driver hyperkit
fi

# starting cluster
minikube start

# enabling ingress
minikube addons enable ingress

# wait 30 secs
echo "Waiting 30 secs...";
sleep 30;

# installing helm-chart and creating spearate namespace 
helm install -f local-values.yaml  --create-namespace --namespace asset "$(sh create-release-name.sh)" .

# mapping hostname to minikube's IP address
echo "$(minikube ip) asset-management.com" | sudo tee -a /etc/hosts

echo "Visit http://asset-management.com for the application"