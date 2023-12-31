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

yum install python36 gcc python3-devel -y  &>> $LOGFILE

VALIDATE $? " install python 3.6 "

id roboshop &>> $LOGFILE
 
 if [ $? -ne 0 ]

 then 

    useradd roboshop

    VALIDATE $? "user roboshop created"

else 

 echo -e "already roboshop user existed $Y skipped $N"

 fi

cd /app  &>> $LOGFILE

if [ $? -ne 0 ]

then 

 mkdir /app

 VALIDATE $? "APP directory created"

 else 

 echo -e " app directory already existed $Y skipped $N "

 fi 

 cd ..

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

    VALIDATE $? "download the payment application"


cd /app &>> $LOGFILE

    VALIDATE $? "change directory to app"


unzip -o /tmp/payment.zip &>> $LOGFILE

    VALIDATE $? "unzip payment application"

pip3.6 install -r requirements.txt &>> $LOGFILE

    VALIDATE $? "install requirements of pip"


cp /home/centos/roboshop_shellscripting/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

    VALIDATE $? "copy payment.service in /etc/systemd"


systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"


systemctl enable payment  &>> $LOGFILE

    VALIDATE $? "enable payment"


systemctl start payment &>> $LOGFILE

    VALIDATE $? "start payment"
