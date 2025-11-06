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

dnf install maven -y
VALIDATE $? "Maven Installed Successfully"

$USERID roboshop

if [ $? -ne 0 ]; then
    echo "user is not present. Hence adding User"
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
else
    echo "User is already present in server. Hence skipping user addition"
fi

mkdir /app 
VALIDATE $? "App Directory created"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
VALIDATE $? "Packages fetched"

cd /app 
VALIDATE $? "traversing into app directory"

rm -rf /app/*
VALIDATE $? "Claning app directory"

unzip /tmp/shipping.zip
VALIDATE $? "Unzipping the code"
 
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl enable shipping 
dnf install mysql -y  &>>$LOG_FILE

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

systemctl start shipping