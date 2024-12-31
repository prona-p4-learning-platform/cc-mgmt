#!/bin/bash

# settings
certificates_dir="user_certificates"

# read namespace from parameter
namespace=$1

# check if namespace is empty
if [ -z "$namespace" ]; then
  echo "Namespace is empty"
  exit 1
fi

# delete namespace
kubectl delete namespace $namespace

# delete user certificate
if [ -f "$certificates_dir/$namespace.crt" ]; then
  rm "$certificates_dir/$namespace.crt"
fi

if [ -f "$certificates_dir/$namespace.key" ]; then
  rm "$certificates_dir/$namespace.key"
fi

if [ -f "$certificates_dir/$namespace.csr" ]; then
  rm "$certificates_dir/$namespace.csr"
fi

echo "Undeployed k8s namespace $namespace and cert"
