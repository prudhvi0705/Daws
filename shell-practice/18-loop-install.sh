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

mkdir -p /var/log/shell-script

LOG_FOLDER="/var/log/shell-script"
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

for i in $@;
do
    dnf list installed $i &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        echo -e "$R $i is not installed $N. Hence installing $i"
        dnf install $i -y &>>$LOG_FILE
        VALIDATE $? $i
    else
        echo -e "$G $i is installed $N"
    fi
done