#!/bin/bash

# read namespace from parameter
namespace=$1

# check if namespace is empty
if [ -z "$namespace" ]; then
  echo "Namespace is empty"
  exit 1
fi

# check if role-template-yaml exists
if [ ! -f role-template.yaml ]; then
  echo "role-template.yaml does not exist"
  exit 1
fi

# create namespace
kubectl create namespace $namespace

# make a copy of the role template and replace the placeholder with the namespace
cp role-template.yaml role.yaml
sed -i "s/%PLACEHOLDER%/$namespace/g" role.yaml

# deploy role.yaml
kubectl apply -f role.yaml -n $namespace

# remove role.yaml
rm role.yaml
