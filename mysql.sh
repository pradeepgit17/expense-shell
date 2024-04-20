#!/bin/bash

USERID=$(id -u)


VALIDATE(){

if [ $1 -ne 0 ]
then
  echo " $2 fails...."
  exit 1
  echo "  $2 success...."
  fi
}


if [ $USERID -ne 0 ]
then
    echo "please run the scripts with roots access"
    exit 1
else
    echo " your are super user"
fi



dnf installl mysql-server -y

VALIDATE $?" installing the mysql"

