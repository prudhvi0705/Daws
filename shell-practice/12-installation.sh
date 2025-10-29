#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo " You should run this script with root privelage"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo "Mysql installation got failed"
    exit 1
else
    echo "Mysql installation got succeded"
fi