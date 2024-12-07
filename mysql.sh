#!/bin/bash

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
    echo "Note a root user"
    exit 1
else
    echo "You are a root user"
fi

dnf module disable mysql -y
VALIDATE $? "mysql installation is"

cp mysql.repo /etc/yum.repos.d/mysql.repo
VALIDATE $? "Copying mysql is"

dnf install mysql-community-server -y
VALIDATE $? "mysql community server installation is"

systemctl enable mysqld
VALIDATE $? "Enabling of mysql is"

systemctl start mysqld
VALIDATE $? "Starting of mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Changing mysql user name and password"

mysql -uroot -pRoboShop@1
VALIDATE $? "Checking mysql username and passworking or not is"