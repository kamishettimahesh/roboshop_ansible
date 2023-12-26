#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-030ba634926b78815
INSTANCES=( "MONGODB" "MYSQL" "RABITMQ" "REDIS" "CATALOUGE" "USER" "CART" "SHIPPING" "PAYMENTS" "WEB")

for i in "${INSTANCES[@]}"

do 

if [ $i == "MONGODB" ] || [ $i == "MYSQL" ] || [ $i == "SHIPPING" ]

then 

    INSTANCE_TYPE="t3.small"
else 
    
    INSTANCE_TYPE="t2.micro"

fi
  IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-030ba634926b78815 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
    echo "$i: $IP_ADDRESS"

done
