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

dnf list installed mysql &>>$LOG_FILE
if [ $? -ne 0 ]; then
    echo -e "$R Mysql is not installed $N. Hence installing mysql"
    dnf install mysql -y &>>$LOG_FILE
    VALIDATE $? MYSQL
else
    echo -e "$G mysql is installed $N"
fi

dnf list installed python3 &>>$LOG_FILE
if [ $? -ne 0 ]; then
    echo -e "$R python is not installed $N. Hence installing python"
    dnf install python3 -y &>>$LOG_FILE
    VALIDATE $? Python
else
    echo -e "$G python is installed $N"
fi

dnf list installed nginx &>>$LOG_FILE
if [ $? -ne 0 ]; then
    echo -e "$R nginx is not installed $N. Hence installing nginx"
    dnf install nginx -y &>>$LOG_FILE
    VALIDATE $? Nginx
else
    echo -e "$G nginx is installed $N"
fi

echo "Script finished at : $(date)"