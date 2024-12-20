#!/bin/bash

AMI=ami-0b4f379183e5706b9
INSTANCE_TYPE=t2.micro
SECURITY_GROUP_ID=sg-05014adf54dad41a6
SUBNET_ID=subnet-074e4b97d8b69706c
INSTANCE_NAME=Anil

IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID --tag-specifications 'ResourceType=instance,Tags=[{Key='Name',Value='$INSTANCE_NAME'}]' --query 'Instances[0].PrivateIpAddress' --output text)

echo "$INSTANCE_NAME PRIVATE IP_ADDRESS: $IP_ADDRESS"


if [ $? -ne 0 ] ; then
    echo "Something went wrong please check ..!"
else
    echo "$INSTANCE_NAME instance Created successfully"
fi