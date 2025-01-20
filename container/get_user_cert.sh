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

# check if $certificates_dir directory exists
if [ ! -d $certificates_dir ]; then
  echo "certificates directory does not exist"
  exit 1
fi

# check if the user cert exists
if [ ! -f $certificates_dir/$username.crt ]; then
  echo "User certificate does not exist"
  exit 1
fi

# Print the certificate as bas64 encoded string
cat $certificates_dir/$username.crt | base64 -w 0

# Print separator
echo -n "--------------------"

# Print the private key as bas64 encoded string
cat $certificates_dir/$username.key | base64 -w 0
