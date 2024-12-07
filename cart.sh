#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE='/tmp/$0-$TIMESTAMP.log'

VALIDATE(){
    if [ $1 -ne 0 ] ; then
        echo "$2 Failed"
        exit 1
    else
        echo "$2 Success"
    fi
}

ID=$(id -u)

if [ $ID -ne 0 ] ; then
    echo "Not a root user"
    exit 1
else
    echo "You are a root user"
fi


dnf module disable nodejs -y
VALIDATE $? "Disabling existing nodejs"

dnf module enable nodejs:18 -y
VALIDATE $? "Enabling nodejs-18 version"

dnf install nodejs -y
VALIDATE $? "Installing node-18 version"

id roboshop
if [ $? -ne 0 ] ; then
    useradd roboshop
    echo "roboshop is user is does not exist...created now."
else
    echo "roboshop user is already there, so skipping"
fi

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "Downloading roboshop-builds"

cd /app
VALIDATE $? "Changed to app directory"

unzip /tmp/cart.zip
VALIDATE $? "Unzippong cart folder"

npm install 
VALIDATE $? "npm installation"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Copying cart.service folder"

systemctl daemon-reload
VALIDATE $? "daemon reloading"

systemctl enable cart
VALIDATE $? "Enabling cart"

systemctl start cart
VALIDATE $? "Starting cart application"