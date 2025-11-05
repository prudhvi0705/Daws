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
echo "Script started at : $Start_date"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2"
        exit 1
    else
        echo "$2"
    fi

}

dnf install mysql-server -y
echo "Installing Mysql package"

systemctl enable mysqld
echo "Enabling Mysql package"

systemctl start mysqld  
echo "Starting Mysql server"

mysql_secure_installation --set-root-pass RoboShop@1
echo "mysql password is set"

End_date="date"
echo "Script Completed at : $End_date"