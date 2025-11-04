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
VALIDATE $? "Disabling Nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enabling Nodejs"

dnf install nodejs -y
VALIDATE $? "Installing Nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Adding Roboshop User"

mkdir /app 
VALIDATE $? "Creating App Directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Fetching zip file from s3"

cd /app 
VALIDATE $? "Traversing into app directory"

unzip /tmp/catalogue.zip
VALIDATE $? "Unzipping the code"

cd /app 
VALIDATE $? "Traversing into app directory"

npm install 
VALIDATE $? "Installed package"

#cp $PWD/catalogue.conf /etc/systemd/system/catalogue.service
#VALIDATE $? "Copied service startup file"

systemctl daemon-reload
VALIDATE $? "Reloading Package"

systemctl enable catalogue 
VALIDATE $? "Enabling service"

systemctl start catalogue
VALIDATE $? "Starting service"

cp $PWD/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Added mongodb repository"

dnf install mongodb-mongosh -y
VALIDATE $? "Installed mongosh client"
