#!/bin/bash

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

openssl genrsa -out $username.key 2048 >/dev/null 2>&1
openssl req -new -key $username.key -out $username.csr -subj "/CN=$username/O=dev/O=example.org" >/dev/null 2>&1
openssl x509 -req -CA ./certs/ca.crt -CAkey ./certs/ca.key -CAcreateserial -days 730 -in $username.csr -out $username.crt -CAserial ca.srl >/dev/null 2>&1

# Print the certificate as bas64 encoded string
cat $username.crt | base64 -w 0

# Print separator
echo -n "-------------------"

# Print the private key as bas64 encoded string
cat $username.key | base64 -w0

# remove the key and csr
rm $username.key
rm $username.csr
rm ca.srl
