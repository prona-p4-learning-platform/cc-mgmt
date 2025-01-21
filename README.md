# cc-mgmt (Cloud Computing Management)
This repository contains all files for the deployment and configuration of the management namespace for the cloud computing labs.


## How it works
This management container is used to manage the kubernetes cluster. The container is deployed in the kubernetes cluster and exposed via a LoadBalancer service. The container runs a SSH server. The SSH server is used to connect to the container and run different shell scripts. The shell scripts are used to manage the kubernetes cluster.


## Available scripts in the container
- `create_user_cert.sh`: Creates a new user certificate by using the admin certificate.
- `get_user_cert.sh`: Retrieves the user certificate.
- `setup_k8s.sh`: Sets up a new kubernetes namespace based on the passed namespace name. It also deploys a role for the user. The access is restricted to the namespace.
- `undeploy_k8s.sh`: Removes the kubernetes namespace and the created certificate.


## Update the mgmt-container
The container is currently hosted in a public repository, because there are no sensitive data in the container and it is easier to deploy the container in the kubernetes cluster. If you want to update the container, you can simply build the container using the `container/Dockerfile` and push it to your own repository. After that, you can update the `k8s/mgmt-deployment.yaml` file with the new image.


## Handling the credentials and certificates
All sensitive credentials and certificates **are not** stored in the image. For this reason, you have to create a secret in the kubernetes cluster. The secret contains the certificates and the kubeconfig file. The secret is mounted to the container and the container uses the certificates and the kubeconfig file to manage the kubernetes cluster.
```bash
export namespace=mgmt

kubectl create secret -n $namespace generic mgmt-certs --from-file=./certs
kubectl create secret -n $namespace generic mgmt-kubeconfig --from-file=./root_kubeconfig.yaml
```

- `mgmt-certs`: Contains the root certificate and key of the kubernetes cluster (`ca.crt` and `ca.key`). These files can be found on the controller of the kubernetes cluster (`/var/lib/rancher/rke2/server/tls/server-ca.key` and `/var/lib/rancher/rke2/server/tls/server-ca.crt`)
- `mgmt-kubeconfig`: Contains the kubeconfig file of the root user of the kubernetes cluster (`root_kubeconfig.yaml`)

## Setup the namespace and container in the kubernetes cluster
- Make sure to add the credentials as described above.
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