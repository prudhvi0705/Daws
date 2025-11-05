#!/bin/bash

set -euo pipefail

trap 'echo "There is error in line $LINENO, Command is: $BASH_COMMAND"' ERR

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
Start_date="date"

mkdir -p $LOG_FOLDER
echo "Script started at : $(date)"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2"
        exit 1
    else
        echo "$2"
    fi

}

dnf module disable redis -y
echo "Disabling Redis"

dnf module enable redis:7 -y
echo "Enabling Redis"

dnf install redis -y 
echo "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
echo "Changing localhost and protected-mode"

systemctl enable redis 
echo "Enabling Redis Service"

systemctl start redis
echo "Starting Redis Service"

echo "Script started at : $(date)"