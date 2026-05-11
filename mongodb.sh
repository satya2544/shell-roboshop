#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_NAME=$( echo $0 | cut -d "." -f1 )
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(data)" | tee -a $LOGS_FILE

if [ $USERID -ne 0 ]; then
     echo "ERROR:: Please run this script with root privelege"
     exit 1
fi

VALIDATE(){
    if [ $? -ne 0 ]; then
       echo -e  "Installing $2 ... $R is failure $N" | tee -a $LOGS_FILE
       exit 1
    else
       echo -e "Installing $2 ... $G is SUCCESS $N" | tee -a $LOGS_FILE
     fi

 }
 
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongodb &>>$LOGS_FILE
VALIDATE $? "Enable MongoDB"

systemctl start mongodb
VALIDATE $? "start MongoDB"