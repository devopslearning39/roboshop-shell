#!/bin/bash

TIMESTAMP=$(date +%f-%h-%m-%s)
LOGFILE='/tmp/$TIMESTAMP-$0.log'
VALIDATE(){
    if [ $1 -ne 0 ] ; then
    echo "Insatllation failed $2"
    exit 1
    else
    echo "Installation success $2"
}

ID=$(id -u)

if [ ID -ne 0 ] ; then
echo "You are not a root user"
        exit 1
    else
echo "You are root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE
VALIDATE $? "copying mongodb repo"


dnf install mongodb-org -y &>> LOGFILE
VALIDATE $? "mongob"

systemctl enable mongod &>>LOGFILE
VALIDATE $? "enabling mongod"

systemctl start mongodn &>> LOGFILE
VALIDATE $? "starting of mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> LOGFILE
VALIDATE $? "remote access of mongod"

systemctl restart mongod &>> LOGFILE
VALIDATE $? "restarting of mongod"