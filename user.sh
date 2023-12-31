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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "RPM Resouces downloaging"

yum install nodejs -y   &>> $LOGFILE

VALIDATE $? "install nodejs"

id roboshop

if [ $? -ne 0 ]
 then 
      useradd roboshop
 VALIDATE $? "Creating roboshop user"
 else
  
  echo -e " roboshop user already existed $Y skipped $N "
fi 

cd /app

if [ $? -ne 0 ]
then 
 mkdir /app

   VALIDATE $? "creating directory /app"
   else 

   echo -e " /app dirctory already existed $Y skipped $N "
   fi

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? " loading user "

 cd /app  &>> $LOGFILE

 VALIDATE $? "change directory /app"

unzip -o /tmp/user.zip &>> $LOGFILE

 VALIDATE $? "unzip user"


 npm install &>> $LOGFILE

  VALIDATE $? "dependencies download"


 cp /home/centos/roboshop_shellscripting/user.service /etc/systemd/system/user.service &>> $LOGFILE

  VALIDATE $? "copy user.service"



 systemctl daemon-reload  &>> $LOGFILE

  VALIDATE $? "daemon reloading"



 systemctl enable user  &>> $LOGFILE

  VALIDATE $? "enabling user"



 systemctl start user &>> $LOGFILE

  VALIDATE $? "start user"



 cp /home/centos/roboshop_shellscripting/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

  VALIDATE $? "copy mongo.repo"


 yum install mongodb-org-shell -y  &>> $LOGFILE

  VALIDATE $? "install mongodb"

mongo --host 172.31.33.83 </app/schema/user.js &>> $LOGFILE

 VALIDATE $? "connection to user and mongodb"
