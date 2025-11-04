#!/bin/bash

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

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y
VALIDATE $? "Installing Mongodb"

systemctl enable mongod 
VALIDATE $? "Enabling Mongodb"

systemctl start mongod 
VALIDATE $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Replaced localhost with 0.0.0.0 to allow remote connections"

systemctl restart mongod
VALIDATE $? "Restarting Mongodb"