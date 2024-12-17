#!/bin/bash

set -e

AMI_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-05014adf54dad41a6
SUBNET_ID=subnet-074e4b97d8b69706c
INSTANCE_NAME=("user" "cart" "shipping" "payment")
ZONE_ID=Z00383512RFXDS653HVHZ
DOMAIN_NAME=jella.fun


for i in "${INSTANCE_NAME[@]}"
do
    if [ $i == "user" ] || [ $i == "cart" ] || [ $i == "shipping" ] ; then
        INSTANCE_TYPE="t2.micro"
    else
        INSTANCE_TYPE="t2.small"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID --tag-specifications 'ResourceType=instance,Tags=[{Key='Name',Value='$i'}]' --query 'Instances[0].PrivateIpAddress' --output text)

    echo -e "Created instance is : \n $i=$IP_ADDRESS \n"

    # Creates route 53 records based on env name

        aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for '$i'"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }'

done