#!/bin/bash
sudo dnf update -y
sudo dnf install -y nginx 
sudo systemctl start nginx 
sudo systemctl enable nginx 
sudo rm -rf /usr/share/nginx/html/*
sudo echo "<h1> Hello From $HOSTNAME </h1>" > /usr/share/nginx/html/index.html
sudo systemctl restart nginx