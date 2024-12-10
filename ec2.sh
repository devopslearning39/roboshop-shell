#!/bin/bash

AMI_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-05014adf54dad41a6
SUBNET_ID=subnet-074e4b97d8b69706c
INSTANCE_NAME=("user" "cart" "shipping" "payment")


for i in $"{INSTANCE_NAME[@]}"
do
    if [ $i == "user" ] || [ $i == "cart" ] || [ $i == "shipping" ] ; then
        INSTANCE_TYPE=t2.micro
    else
        INSTANCE_TYPE=t2.small
    fi

IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID --tag-specifications 'ResourceType=instance,Tags=[{Key='Name',Value='$INSTANCE_NAME'}]' --query 'Instances[0].PrivateIpAddress' --output text)

if [ $? -ne 0 ] ; then
    echo "An error occured"
else
    echo -e "Successfully created instance is : \n $INSTANCE_NAME : $IP_ADDRESS \n"
fi

done


