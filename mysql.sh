#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
echo "please run the scripts with roots access"
exit 1
echo "your are super user"

fi 

dnf install mysql-server -y


