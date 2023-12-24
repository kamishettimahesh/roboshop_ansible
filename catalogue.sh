#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F_%H:%M:%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){

if [ $1 -ne 0 ]

then 
   echo -e " $2 .......$R FAILED $N"

else 

   echo -e " $2 .......$G SUCCESS $N"

fi
}

ID=$(id -u)

if [ $ID -ne 0 ]
then
     echo -e "$R error: please run with root user $N"
     exit 1
else 
     echo -e " $G you are using root user $N "
fi 

dnf module disable nodejs -y  &>> $LOGFILE
VALIDATE $? " Disable nodejs current version "
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? " Enable nodejs:18 version "
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? " install nodejs "

 id roboshop
    if [ $? -ne 0 ]
    then
          useradd roboshop
           VALIDATE $? "roboshop user creation"
    else
        echo -e "roboshop user already exist $Y SKIPPING $N"
    fi

mkdir -p /app &>> $LOGFILE
 VALIDATE $? " directory app created "
    
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

 VALIDATE $? " loading catalogue zip "

 cd /app  &>> $LOGFILE
  VALIDATE $? " change directory /app "

unzip -o /tmp/catalogue.zip &>> $LOGFILE
 VALIDATE $? " unzip catalogue in  /app "

npm install &>> $LOGFILE
 VALIDATE $? " install dependencies by using npm "

cp /home/centos/roboshop_shellscripting/catalogue.service /etc/systemd/system/catalogue.service  &>> $LOGFILE
  
  VALIDATE $? "copy catalogue.service"

systemctl daemon-reload &>> $LOGFILE

  VALIDATE $? "daemon reload"

systemctl enable catalogue &>> $LOGFILE

  VALIDATE $? "enable catalogue"

systemctl start catalogue  &>> $LOGFILE
   VALIDATE $? "start catalogue"

cp /home/centos/roboshop_shellscripting/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copy mongo.repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "install mongodb"

mongo --host 172.31.33.83 </app/schema/catalogue.js &>> $LOGFILE


VALIDATE $? "mongo host applied to catalogue"













