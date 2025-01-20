#!/bin/bash

# settings
certificates_dir="user_certificates"

# read username from parameter
username=$1

# check if username is empty
if [ -z "$username" ]; then
  echo "Username is empty"
  exit 1
fi

# check if certs directory exists
if [ ! -d certs ]; then
  echo "certs directory does not exist"
  exit 1
fi

# check if $certificates_dir directory exists
if [ ! -d $certificates_dir ]; then
  mkdir $certificates_dir
fi

# check if the user cert or k8s namespace already exists
if [ -f $certificates_dir/$username.crt ]; then
  echo "User certificate already exists"
  exit 1
fi

# create user certificate
openssl genrsa -out $certificates_dir/$username.key 2048 >/dev/null 2>&1
openssl req -new -key $certificates_dir/$username.key -out $certificates_dir/$username.csr -subj "/CN=$username/O=dev/O=example.org" >/dev/null 2>&1
openssl x509 -req -CA ./certs/ca.crt -CAkey ./certs/ca.key -CAcreateserial -days 730 -in $certificates_dir/$username.csr -out $certificates_dir/$username.crt -CAserial ca.srl >/dev/null 2>&1

# Print the certificate as bas64 encoded string
cat $certificates_dir/$username.crt | base64 -w 0

# Print separator
echo -n "--------------------"

# Print the private key as bas64 encoded string
cat $certificates_dir/$username.key | base64 -w 0

# remove ca.srl file
rm ca.srl
rm $certificates_dir/$username.csr
