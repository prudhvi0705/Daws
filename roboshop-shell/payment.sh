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

dnf install python3 gcc python3-devel -y
VALIDATE $? "Python3 is installed"

$USERID roboshop
if [ $? -ne 0 ]; then
    echo "User is not present in server.Hence adding user"
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
else
    echo "User is already present in server"
fi

mkdir /app 
VALIDATE $? "creating app directory"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip 
VALIDATE $? "Fetching code"
cd /app 
VALIDATE $? "Traversing into app directory"
rm -rf /app/*
VALIDATE $? "clearing packages"
unzip /tmp/payment.zip
VALIDATE $? "Unzipping the code"

pip3 install -r requirements.txt
VALIDATE $? "Installing requirements"

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service
VALIDATE $? "creating service file"

systemctl daemon-reload
systemctl enable payment 
systemctl start payment
