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

dnf install nginx -y &>> $LOGFILE
 VALIDATE $? "Install nginx"

systemctl enable nginx   &>> $LOGFILE

 VALIDATE $? "enable nginx"


systemctl start nginx  &>> $LOGFILE

 VALIDATE $? "start nginx"


rm -rf /usr/share/nginx/html/*  &>> $LOGFILE

 VALIDATE $? "remove default nginx page"


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

 VALIDATE $? "load web page"


cd /usr/share/nginx/html &>> $LOGFILE

 VALIDATE $? "change directory"

unzip /tmp/web.zip  &>> $LOGFILE

 VALIDATE $? "unzip web"



cp /home/centos/roboshop_shellscripting/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>> $LOGFILE

  VALIDATE $? "copy roboshop.conf"


systemctl restart nginx &>> $LOGFILE

 VALIDATE $? "restart nginx"
 