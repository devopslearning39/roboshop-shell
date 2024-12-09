#!/bin/bash

IMAGE_ID=i-009c2b75604e28373
INSTANCE_TYPE=t2.micro
SECURITY_GROUP_ID=sg-05014adf54dad41a6
SUBNET_ID=subnet-074e4b97d8b69706c

aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID

echo "Created new instance"