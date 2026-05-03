#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-08aa3e7b6d2e04568"

for instance in "$@"
do
   INSTANCE_ID=$(aws ec2 run-instances \
      --image-id "$AMI_ID" \
      --instance-type t3.micro \
      --security-group-ids "$SG_ID" \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
      --query 'Instances[0].InstanceId' \
      --output text)

   echo "Created instance: $INSTANCE_ID"

   # wait until instance gets IP
   sleep 10

   if [ "$instance" != "frontend" ]; then
        
      IP=$(aws ec2 describe-instances \
         --instance-ids "$INSTANCE_ID" \
         --query 'Reservations[0].Instances[0].PrivateIpAddress' \
         --output text)
   else
     
      IP=$(aws ec2 describe-instances \
         --instance-ids "$INSTANCE_ID" \
         --query 'Reservations[0].Instances[0].PublicIpAddress' \
         --output text)
   fi    

   echo "$instance: $IP"

done