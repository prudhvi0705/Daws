#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo -e "$R You should run this script with root privelage $N"
    exit 1
fi

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 installation got failed"
        exit 1
    else
        echo "$2 installation got succeded"
    fi

}

dnf list installed mysql
if [ $? -ne 0 ]; then
    echo -e "$R Mysql is not installed $N. Hence installing mysql"
    dnf install mysql -y
    VALIDATE $? MYSQL
else
    echo -e "$G mysql is installed $N"
fi

dnf list installed python3
if [ $? -ne 0 ]; then
    echo -e "$R python is not installed $N. Hence installing python"
    dnf install python3 -y
    VALIDATE $? Python
else
    echo -e "$G python is installed $N"
fi

dnf list installed nginx
if [ $? -ne 0 ]; then
    echo -e "$R nginx is not installed $N. Hence installing nginx"
    dnf install nginx -y
    VALIDATE $? Nginx
else
    echo -e "$G nginx is installed $N"
fi