#!/bin/bash

# Install needed packages. Please add to this list if you discover additional prerequisites.
sudo yum install -y apr-devel
sudo yum install -y bison
sudo yum install -y bzip2-devel
sudo yum install -y flex
sudo yum install -y gcc
sudo yum install -y libcurl-devel
sudo yum install -y libevent-devel
sudo yum install -y libkadm5
sudo yum install -y libxml2
sudo yum install -y libxml2-devel
sudo yum install -y perl-ExtUtils-Embed
sudo yum install -y python-devel
sudo yum install -y readline-devel
sudo yum install -y zlib
sudo yum install -y zlib-devel

# Install pip
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo rpm -Uvh epel-release-latest-6.noarch.rpm
sudo yum install -y python-pip

sudo pip install lockfile paramiko psutil setuptools
