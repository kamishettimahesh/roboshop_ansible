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

yum install maven -y  &>> $LOGFILE

id roboshop

 if [ $? -ne 0 ]

 then 

     useradd roboshop
     VALIDATE $? "creating user roboshop"
else

echo -e "already roboshop user existed $Y Skipping $N"

fi

cd /app

if [ $? -ne 0 ]

then 

 mkdir /app

 VALIDATE $? "app directory created"
 else 
  echo -e "directory already existed $Y skipping $N"

fi

cd ..

 VALIDATE $? "exit app director"


curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

 VALIDATE $? "load shipping application"


cd /app &>> $LOGFILE

 VALIDATE $? "switch to app directory"


unzip -o /tmp/shipping.zip &>> $LOGFILE

 VALIDATE $? "unzip shipping application"


mvn clean package &>> $LOGFILE

 VALIDATE $? "maven clean package"

mv target/shipping-1.0.jar shipping.jar  &>> $LOGFILE

 VALIDATE $? "move jar file"


cp /home/centos/roboshop_shellscripting/shipping.service /etc/systemd/system/shipping.service  &>> $LOGFILE

 VALIDATE $? "loading shipping service"

systemctl daemon-reload &>> $LOGFILE

 VALIDATE $? "daemon reload"


systemctl enable shipping &>> $LOGFILE

 VALIDATE $? "enable shipping"


systemctl start shipping &>> $LOGFILE

 VALIDATE $? "start shipping"


yum install mysql -y  &>> $LOGFILE

 VALIDATE $? "install mysql"


mysql -h <172.31.85.54> -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>> $LOGFILE

 VALIDATE $? "load schema"


systemctl restart shipping &>> $LOGFILE

 VALIDATE $? "restart shipping"
