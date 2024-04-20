#!/bin/bash

USERID=$(id -u)
TIMESTAMP=($date +%F-H%-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2... $R FAILURE $N"
        exit 1
    else
        echo  -e "$2...$G SUCCESS $N "
    fi
}

if [ $USERID -ne 0 ]
then
    echo "please run the scripts with roots access"
    exit 1
else
    echo " your are super user"
fi



dnf install mysql-server -y &>>$LOGFILE

VALIDATE $? "installing the mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root password"

mysql -h db.pradeep17.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
     mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
     VALIDATE $? "MySQL Root password Setup"
else
    echo -e "my root password is already setup $Y Skipping $N "
 fi






