#!/bin/bash
instances=("mongodb" "catalogue" "redis" "user" "cart" "mysql" "shipping" "rabbitmq" "payment" "web")
echo "all instances ${instances[@]}"
image_id="ami-09c813fb71547fc4f"
instance_type=""
security_group_id="sg-04b86a12980ec1b5f"
for i in ${instances[$@]}
do
if [[ "$i" == "mongodb" || "$i" == "mysql" ]] 
then
instance_type="t3.medium"
else
instance_type="t2.micro"
fi
aws ec2 run-instances \
  --image-id $image_id \
  --instance-type $instance_type \
  --security-group-ids $security_group_id \
  
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" 
| jq '.Instances[].PrivateIpAddress'
done
