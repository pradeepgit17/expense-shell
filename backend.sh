#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){

   if [ $1 -ne 0 ]
then
   echo  -e" $2... installation is $R fails $N"
   exit 1
else
    echo -e " $2... installation is $G SUccess $N"
fi
}

if [ $USERID -ne 0 ]
then
    echo " please run the scripts with root user"
    exit 1
else 
    echo  " your are super user"

fi

dnf module disable nodejs -y
VALIDATE $? " disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

#useradd expense
#VALIDATE $? "creating expense user"

id expense

if [ $? -ne 0 ]
then 
   useradd expense
   VALIDATE $? "creating expense user"
else

    echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE $? "Creating the app dir"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "downloading the backend code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code"

npm install
VALIDATE $? "Installing nodejs dependencies"

 cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon Reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Client"

mysql -h 172.31.20.179 -uroot -pExpenseApp@1 -e  < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"


