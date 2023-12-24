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

cp mongo.repo /etc/yum.repos.d/mongo.repo  &>> $LOGFILE

VALIDATE $? "COPY MONGO REPO"


dnf install mongodb-org -y  &>> $LOGFILE

VALIDATE $? "Install mongodb-org"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabled mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "started mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "root permission mongodb"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "restarted mongodb"
