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

dnf install nginx -y
VALIDATE $? "Installing of nginx"

systemctl enable nginx
VALIDATE $? "enabling nginx"

systemctl start nginx
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removing default nginx files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "dowmload roboshop web app"

cd /usr/share/nginx/html
VALIDATE $? "navigated or moved directory to nginx"

unzip /tmp/web.zip
VALIDATE $? "unzipping web app folder"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
VALIDATE $? "Copying roboshop.conf file"

systemctl restart nginx
VALIDATE $? "restarting nginx server"