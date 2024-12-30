# cc-mgmt (Cloud Computing Management)
This repository contains all files for the deployment and configuration of the management namespace for the cloud computing labs.

## How it works
TODO

## Handling the credentials and certificates
```bash
export namespace=mgmt

kubectl create secret -n $namespace generic mgmt-certs --from-file=./certs
kubectl create secret -n $namespace generic mgmt-kubeconfig --from-file=./root_kubeconfig.yaml
```

## Update the mgmt-container
TODO

## Setup the mgmt namespace
- Set a password in the `k8s/mgmt-deployment.yaml` file (line 25). This is the SSH password for the mgmt container.
```bash
export namespace=mgmt

# Create the namespace
kubectl create namespace $namespace

# Create the deployment
kubectl apply -n $namespace -f k8s/mgmt-deployment.yaml

# Get the load balancer IP
kubectl get svc -n $namespace mgmt-app-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
```