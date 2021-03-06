# A list of commands - for quickly setting up VPS for deploying Rails Application
# using nginx, Ubuntu(Latest Stable LTS : 12.04), Unicorn, MySQL and Capistrano
# Author: Ramesh Jha (ramesh@rameshjha.com),(http://blog.sudobits.com)
# License: MIT 

# setting hostname (optional)
echo "<YOUR_HOSTNAME>" > /etc/hostname
hostname -F /etc/hostname


# Update System Packages
apt-get -y update
apt-get -y upgrade


# fix for locale error on Ubuntu (optional)
apt-get install --reinstall language-pack-en
locale-gen en_US.UTF-8

# for apt
apt-get -y install python-software-properties

# install git and curl
apt-get -y install curl git-core

# Install Server (nginx)
apt-add-repository -y ppa:nginx/stable
apt-get -y update
apt-get -y install nginx

# start/stop nginx (in Ubuntu 12.04 LTS)
sudo service nginx start
sudo service nginx stop
sudo service nginx restart

# or

sudo /etc/init.d/nginx start
sudo /etc/init.d/nginx stop
sudo /etc/init.d/nginx restart


# For Installing nodejs
sudo apt-add-repository -y ppa:chris-lea/node.js
sudo apt-get -y update
sudo apt-get -y install nodejs

# Create User and add it to sudo group
adduser example_user --ingroup sudo


## setup keys for ssh login

# On Local Computer
ssh-keygen
scp ~/.ssh/id_rsa.pub example_user@IP_ADDRESS:

# On remote server
mkdir .ssh
mv id_rsa.pub .ssh/authorized_keys


# Install MySQL Database and its Dependencies
sudo apt-get -y install mysql-server libmysql++-dev

#create a production database (mysql)
mysql -u root -p
create database YOUR_DB_NAME;
grant all on YOUR_DB_NAME.* to DB_USER@localhost identified by 'your_password_here';
exit


# setup ruby
## Install rbenv using this installer
## https://github.com/fesplugas/rbenv-installer
curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

## update .bashrc according to rbenv installer's instruction
# install dependencies 
rbenv bootstrap-ubuntu-12-04

# latest ruby 1.9.3-p385
rbenv install 1.9.3-p385
rbenv rehash
rbenv global 1.9.3-p385

# install bundler and rake
gem install bundler --no-ri --no-rdoc
gem install rake --no-ri --no-rdoc
rbenv rehash

# setup git and github or bitbucket or equivalent one!

# remove default nginx config
sudo rm /etc/nginx/sites-enabled/default


# deployment using capistrano && unicorn
# update gemfile

# Deploy with Capistrano
# update Gemfile
## gem 'capistrano'
## gem 'mysql2'
## gem 'unicorn'
## gem 'capistrano'

bundle

# now capify!!
capify .

## update capfile and config/deploy.rb
## add config/nginx.conf
## add unicorn.rb
## add unicorn_init.sh and make it executable
## add delayed job scripts (rails generate delayed_job && capistrano recepies)

## commit the latest changes and update database.yml (youmay want to add it to gitignore file and 
## and update it manually on the server, for security reasons, of course)

# Deploying to VPS
cap deploy:setup
cap deploy

# Run Database Migrations
cap deploy:migrate

# for delayed job and sending emails (if you're using)
cap deploy:start

## read this (and comment there) if you need any help : http://blog.sudobits.com/2013/01/07/how-to-deploy-rails-application-to-vps/



