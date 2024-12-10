#!/bin/bash

AMI_ID=ami-0b4f379183e5706b9
INSTANCE_TYPE=t2.micro
SECURITY_GROUP_ID=sg-05014adf54dad41a6
INSTANCE_NAME=USER

aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --subnet-id subnet-074e4b97d8b69706c --resources $AMI_ID --tags Key=Name,Value=$INSTANCE_NAME

if [ $? -ne 0 ] ; then
    echo "An error occured"
else
    echo "Successfully created instance is : "
fi