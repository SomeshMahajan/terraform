#!/bin/bash
sudo apt update -y
sudo apt install nginx -y  
sudo systemctl start nginx 
sudo systemctl enable nginx 
sudo rm -rf /var/www/html/*
sudo echo "<h1> Hello From $HOSTNAME </h1>" > /var/www/html/index.html
sudo systemctl restart nginx