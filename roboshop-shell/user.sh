#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo -e " $R You should run this script with root privelage $N "
    exit 1
fi

mkdir -p /var/log/roboshop-shell

LOG_FOLDER="/var/log/roboshop-shell"
SCRIPT_NAME=$(echo $0 | cut -d "." -f 1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.prudhvii.fun"

mkdir -p $LOG_FOLDER
echo "Script started at : $(date)"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 installation got failed"
        exit 1
    else
        echo "$2 installation got succeded"
    fi

}

dnf module disable nodejs -y
dnf module enable nodejs:20 -y

dnf install nodejs -y
VALIDATE $? "Installing Nodejs"

$USERID roboshop

if [ $? -ne 0 ]; then
    echo "user is not present. Hence adding User"
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
else
    echo "User is already present in server. Hence skipping user addition"
fi

mkdir /app 
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 
VALIDATE $? "Fetching code"
cd /app 
rm -rf /app/*
unzip /tmp/user.zip
npm install 

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "Copied service startup file"

systemctl daemon-reload
systemctl enable user 
systemctl start user