#!/bin/bash
instances=("mongodb" "catalogue" "redis" "user" "cart" "mysql" "shipping" "rabbitmq" "payment" "web")
echo "all instances ${instances[@]}"
image_id="ami-09c813fb71547fc4f"

security_group_id="sg-04b86a12980ec1b5f"
for i in "${instances[@]}"
do
  echo "$i"
done
