#!/bin/bash
# yum update -y
echo User: `whoami` > /tmp/user.txt

# Install the yum repository containing nginx
rpm -Uvh http://nginx.org/packages/rhel/7/noarch/RPMS/nginx-release-rhel-7-0.el7.ngx.noarch.rpm

# Install NGINX
sudo yum install nginx -y > /tmp/yum_nginx.log

# Start it
systemctl start nginx
systemctl enable nginx

# Copy the index file after the installation of nginx
cp /tmp/index.html /usr/share/nginx/html/


