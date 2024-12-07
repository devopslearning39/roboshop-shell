#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE='/tmp/$0-$TIMESTAMP.LOG'

VALIDATE(){
    if [ $1 -ne 0 ] ; then
        echo "$2 Failed.."
        exit 1
    else
        echo "$2 Success"
    fi
}

ID=$(id -u)

if [ $ID -ne 0 ] ;then
    echo "Not a root user"
    exit 1
else
    echo "You are a root user"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "Downloading of remi repo is"

dnf module enable redis:remi-6.2 -y
VALIDATE $? "Enabling remi repo"

dnf install redis -y
VALIDATE $? "Installing remi repo"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connection"

systemctl enable redis
VALIDATE $? "Enabling of redis"

systemctl start redis
VALIDATE $? "Starting of redis"