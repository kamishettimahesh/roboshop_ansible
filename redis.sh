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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>> $LOGFILE

VALIDATE $? "RPM SERVICE DOWNLOAD"

yum module enable redis:remi-6.2 -y  &>> $LOGFILE

VALIDATE $? "enable redis 6.2"


yum install redis -y  &>> $LOGFILE

VALIDATE $? "install redis"



sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  &>> $LOGFILE

VALIDATE $? "IP address change"


systemctl enable redis   &>> $LOGFILE

VALIDATE $? "enable redis"


systemctl start redis  &>> $LOGFILE

VALIDATE $? "redis redis"
