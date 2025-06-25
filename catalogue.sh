#!/bin/bash
LOGS_DIR=/tmp
scriptname=$0
DATE=$(date +%F-%H-%M-%S)
LOG_FILE=$LOGS_DIR/$scriptname-$DATE.log
R="\e[0;31m"
G="\e[0;32m"
Y="\e[0;33m"
N="\e[0m"
userid=$(id -u)
if [ $userid -ne 0 ]
then
 echo "not a root user proceed with root access"
 exit 1
 fi
validate(){
    if [ $1 -ne 0 ]
    then
    echo -e "$2... $R failure $N"
    else
    echo -e "$2.... $G success $N"
    fi
 }
 dnf module disable nodejs -y 
 validate $? "disable nodejs"
dnf module enable nodejs:20 -y
validate $? "enable nodejs"
dnf install nodejs -y 
validate $? "installing nodejs"
id roboshop
if [ $? -ne 0 ]
then 
useradd roboshop 
validate $? "adding user roboshop"
else 
echo "user roboshop exists"
fi
DIR="/home/ec2-user/app"

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist. Creating..."
    mkdir -p "$DIR"
    validate $? "created app directory"
else
    echo "$DIR exists."
fi
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
 validate $? "downloaded catalogue.zip in tmp "
 cd /app 
 validate $? "cd into app"
 unzip /tmp/catalogue.zip 
 validate $? "unzip into app directory"
 npm install 
 validate $? "installing dependencies"
 cp /home/ec2-user/catalogue.service   /etc/systemd/system/catalogue.service
 validate $? "copying catalogue.service"
 systemctl daemon-reload
validate $? "load the service"
systemctl enable catalogue
validate $? "enable service"
systemctl start catalogue
validate $? "start the service"
cp /home/ec2-user/mongo.repo  /etc/yum.repos.d/mongo.repo
validate $? "copying mongo.repo"
dnf install -y mongodb-mongosh
validate $? "installing mongodb-mongosh"
mongosh --host  </app/schema/catalogue.js
validate $? "loading schema"

