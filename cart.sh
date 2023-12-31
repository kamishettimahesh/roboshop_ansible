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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y  &>> $LOGFILE

VALIDATE $? "Enabling NodeJS:18"

dnf install nodejs -y   &>> $LOGFILE

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

   cd ..

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? " loading cart "

 cd /app  &>> $LOGFILE

 VALIDATE $? "change directory /app"

unzip -o /tmp/cart.zip &>> $LOGFILE

 VALIDATE $? "unzip cart"


 npm install &>> $LOGFILE

  VALIDATE $? "dependencies download"


 cp /home/centos/roboshop_shellscripting/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

  VALIDATE $? "copy cart.service"



 systemctl daemon-reload  &>> $LOGFILE

  VALIDATE $? "daemon reloading"



 systemctl enable cart  &>> $LOGFILE

  VALIDATE $? "enabling cart"



 systemctl start cart &>> $LOGFILE

  VALIDATE $? "start cart"



 