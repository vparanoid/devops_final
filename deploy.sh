#!/bin/bash

echo "WARNING: Using ~/.aws/credentials for ASW login"

WD=`pwd`
TF_DIR="${WD}/terraform-ec2"
ANS_DIR="${WD}/ansible"
INSTANCE_SSH_KEY="${WD}/SGK1.pem"

echo "======== CREATING VPC ======"

cd ${TF_DIR}
terraform init   || exit 1
terraform plan   || exit 1
terraform apply

WEB_ID=`aws ec2 describe-instances | jq '."Reservations"[] | ."Instances"[] | ."InstanceId"' | tr -d '"'`
WEB_IP=`aws ec2 describe-instances | jq '."Reservations"[] | ."Instances"[] | ."PublicIpAddress"' | tr -d '"' `
WEB_IP=`echo ${WEB_IP} | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

echo "======== CHECK INSTANCE ======"

#ping ${WEB_IP} -c 10

echo "======== CONFIGURING INSTANCE ======"

cd ${ANS_DIR}
echo "[aws_ec2_instance_ip]" > inventory.yml
echo -e ${WEB_IP} >> inventory.yml

ansible-playbook playbook.yml -i inventory.yml --key-file "${INSTANCE_SSH_KEY}" --diff -v

echo "======== CHECK SERVICE ======"
ping ${WEB_IP} -c 10
curl http://${WEB_IP}/

