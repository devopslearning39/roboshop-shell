#!/bin/bash

TIMASTAMP=$(date +%F-%H-%M-%S)

LOGFILE='tmp/$0-$TIMESTAMP'


VALIDATE(){
    if [ $1 -ne 0 ] ; then
        echo "$2 Failed"
        exit 1
    esle
        echo "$2 Success"
    fi
}

ID=$(id -u)

if [ $ID -ne 0 ] ; then
    echo "Not a root user"
    exit 1
esle
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
esle
    echo "roboshop user is already there, so skipping"
fi

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "Downloaded application code"

cd /app 
VALIDATE $? "Navigated to app directory"

unzip -o /tmp/user.zip
VALIDATE $? "Unzipping the code"

npm install
VALIDATE $? "Installing npm dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
VALIDATE $? "Copying user.service file"

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl enable user 
VALIDATE $? "Enabling user"

systemctl start user
VALIDATE $? "Staring user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo repo"

dnf install mongodb-org-shell -y
VALIDATE $? "Installing mongodb org shell"

mongo --host mongodb.jella.fun </app/schema/user.js
VALIDATE $? "Loading user data into mongodb"