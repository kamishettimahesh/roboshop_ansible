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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Configure YUM Repos from the script provided by vendor."

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> $LOGFILE

VALIDATE $? "Configure YUM Repos for RabbitMQ."


yum install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Install rabbitmq"


systemctl enable rabbitmq-server &>> $LOGFILE

VALIDATE $? "enabling RabbitMQ."

systemctl start rabbitmq-server &>> $LOGFILE

VALIDATE $? "start rabbitmq"



rabbitmqctl add_user roboshop roboshop123  &>> $LOGFILE

VALIDATE $? "user and passwd added"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOGFILE

VALIDATE $? "set permissions"

