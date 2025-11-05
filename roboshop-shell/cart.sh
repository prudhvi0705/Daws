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

dnf module disable nodejs -y
echo "Disabled nodejs"

dnf module enable nodejs:20 -y
echo "Enabled nodejs"

dnf install nodejs -y
echo "Installed nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
echo "Added roboshop user"

mkdir /app 
echo "Created app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
echo "Fetching packages"

cd /app
echo "traversed into app directory"

unzip /tmp/cart.zip
echo "Unzipping the cart"

cd /app 

npm install 
echo "Installed npm"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
echo "Created service"

systemctl daemon-reload
echo "daemon reloaded"

systemctl enable cart 
echo "Enabled cart"

systemctl start cart
echo "started cart"