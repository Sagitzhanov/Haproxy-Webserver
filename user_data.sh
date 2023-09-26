#!/bin/bash
# Ubuntu 20.04

sudo apt update -y
sudo apt install awscli -y
sudo apt install ansible -y



# copy hosts.txt index install ssh-pem haproxy 
aws s3 cp s3://s3-s-s-bucket/hosts.txt /home/ubuntu/hosts.txt
aws s3 cp s3://s3-s-s-bucket/index.html.j2 /home/ubuntu/index.html.j2
aws s3 cp s3://s3-s-s-bucket/install.yml /home/ubuntu/install.yml
aws s3 cp s3://s3-s-s-bucket/haproxy.cfg /home/ubuntu/haproxy.cfg
aws s3 cp s3://s3-s-s-bucket/frankfurt.pem /home/ubuntu/frankfurt.pem


mkdir /home/ubuntu/test

chmod 400 /home/ubuntu/frankfurt.pem

ansible-playbook -i /home/ubuntu/hosts.txt /home/ubuntu/install.yml
