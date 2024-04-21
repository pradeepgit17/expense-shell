#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
  echo " please run the script with root user"
  exit 1
else
  echo "your are super user"
fi

dnf install nginx -y 