




#!/bin/bash

kind

if [ $? -ne 0 ]; then

	curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
	chmod +x ./kind
	mv ./kind /usr/local/bin
fi

terraform

if [ $? -ne 0 ]; then

        TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
	wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
	unzip terraform_${TER_VER}_linux_amd64.zip
	mv terraform /usr/local/bin/
fi

terraform destroy --auto-approve
terraform apply --auto-approve 



export KUBECONFIG=./test-cluster-config
kubectl get nodes 

a=`kubectl get nodes -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}'`

echo $a
while [ "$(kubectl get nodes -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}')" != "True True" ]; do
   sleep 5
   echo "Waiting for Nodes to be ready."
done

kubectl apply -f app.yaml

while [ "$(kubectl get pods -l=app='web-nginx' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
   echo "Waiting for Application to be ready"
done



