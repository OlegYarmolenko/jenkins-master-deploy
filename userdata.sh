#!/bin/bash
sudo su
yum install -y wget
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
amazon-linux-extras install epel -y
yum install jenkins java-1.8.0-openjdk-devel git -y
systemctl enable jenkins && systemctl restart jenkins
