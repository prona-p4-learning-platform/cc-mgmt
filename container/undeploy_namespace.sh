#!/bin/bash

# read namespace from parameter
namespace=$1

# check if namespace is empty
if [ -z "$namespace" ]; then
  echo "Namespace is empty"
  exit 1
fi

# delete namespace
kubectl delete namespace $namespace
