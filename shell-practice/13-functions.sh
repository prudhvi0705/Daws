#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo " You should run this script with root privelage"
    exit 1
fi


VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 installation got failed"
        exit 1
    else
        echo "$2 installation got succeded"
    fi

}

dnf install mysql -y
VALIDATE $? MYSQL
dnf install python3 -y
VALIDATE $? Python
dnf install nginx -y
VALIDATE $? Nginx