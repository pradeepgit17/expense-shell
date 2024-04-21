#!/bin/bash

USERID=$(id -u)

if [ USERID -ne 0 ]
then
    echo " please run the scripts with root user"
    exit 1
else 
    echo  " your are super user"

f1

dnf module disable nodejs -y