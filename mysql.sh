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
 yum module disable mysql -y 
 validate $? "disable mysql"
 cp /home/ec2-user/roboshop-shell-2025/mysql.repo /etc/yum.repos.d/mysql.repo
 validate $? "copying mysql.repo"
 yum install mysql-community-server -y &>>$LOG_FILE
validate $? "installing mysql-server"
systemctl enable mysqld &>>$LOG_FILE
validate $? "enable mysql"
systemctl start mysqld &>>$LOG_FILE
validate $? "start mysql"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
validate $? "changing password"