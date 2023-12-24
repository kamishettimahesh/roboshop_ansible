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

yum module disable mysql -y  &>> $LOGFILE

VALIDATE $?  "disable mysql"

cp /home/centos/roboshop_shellscripting/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $?  "loading mysql.repo"


yum install mysql-community-server -y  &>> $LOGFILE

VALIDATE $?  "install mysql server"


systemctl enable mysqld  &>> $LOGFILE

VALIDATE $?  "enable mysql"


systemctl start mysqld  &>> $LOGFILE

VALIDATE $?  "start mysql"


mysql_secure_installation --set-root-pass RoboShop@1  &>> $LOGFILE

VALIDATE $?  "set user and passwd mysql"



mysql -uroot -pRoboShop@1  &>> $LOGFILE

VALIDATE $?  "user and passwd mysql"
