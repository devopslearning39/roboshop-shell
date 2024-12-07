#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE='/tmp/$0-$TIMESTAMP.log'

VALIDATE(){
    if [ $1 -ne 0 ] ; then
        echo "failed $2"
        exit 1
    else
        echo "Success $2"
    fi
}

ID=$(id -u)

if [ $ID -ne 0 ] ; then
    echo "You are not root user"
    exit 1
else
    echo "You are root user"
fi

dnf module disable nodejs -y
VALIDATE $? "Disbling old version of nodejs " &>> LOGFILE

dnf module enable nodejs:18 -y
VALIDATE $? "Enabling of nodejs " &>> LOGFILE

dnf install nodejs -y
VALIDATE $? "Installation of nodejs " &>> LOGFILE

id roboshop

if [ $? -ne 0 ] ; then
    useradd roboshop
    VALIDATE $? "roboshop user added "
else
    echo "roboshop user is already there, so skipping adding the user"
fi

mkdir -p /app
VALIDATE $? "app directory creation is "

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Downloading catalogue app"

cd /app
unzip -o /tmp/catalogue.zip
VALIDATE $? "Unzipping catalogue is "

npm install
VALIDATE $? "npm installation is "

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue.service repo is "

systemctl daemon-reload
VALIDATE $? "daemon reload is "

systemctl enable catalogue
VALIDATE $? "catalogue enable is "

systemctl start catalogue
VALIDATE $? "Catalogue starting is "

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y
VALIDATE $? "Installing MongoDB client is "

mongo --host mongodb.jella.fun </app/schema/catalogue.js
VALIDATE $? "Loading catalouge data into MongoDB is "