#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl start nginx 
systemctl enable nginx 