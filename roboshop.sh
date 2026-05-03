#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-08aa3e7b6d2e04568"

for instance in $@

do

   INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 
   --instance-type t3.micro --security-group-ids
   sg-08aa3e7b6d2e04568 --tag-specifications
   'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]"
   --query 'Instances[0].InstanceId' --output text)

   if [ $instance != "frontend" ]; then
        
    IP=$(aws ec2 describe-instances --instance-ids i-02b735aabff2720ec --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    else
     
    IP=$(aws ec2 describe-instances --instance-ids i-02b735aabff2720ec --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi    
    

    echo "$instance: $IP"

done