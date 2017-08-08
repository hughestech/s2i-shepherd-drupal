#!/bin/bash
# variables for mysql database
MYSQL_USER=user123
MYSQL_PASSWORD=pass12345678
MYSQL_DATABASE=drupal8
MYSQL_ROOT_PASSWORD=root12345678
DB_HOST=dbhost

#Application Container
appName=hughestech/opensocial

#Mysql hostname. See https://docs.docker.com/engine/reference/commandline/network_create/
sudo docker network create $DB_HOST

# TODO - add environment variables, using db variables
# https://hub.docker.com/r/centos/mysql-56-centos7/
# NOTE: we do not want the data to be saved across builds, so we are not mapping volumes. This means, the data will be lost when we restart the container. This is the expected result. We only need to mysql so we can run ‘drush install’. 
sudo docker run -d --name mysql_database -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --network=$DB_HOST -p 3306:3306 centos/mysql-56-centos7
sudo docker ps

# Creating builder image. Not sure if we need to pass env vars here. As long as they are added to dockerfile.
sudo docker build -t drupals2ibuilder . #-e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

# Creating the application image
# Run builder, pass env vars to builder image
sudo s2i build opensocial drupals2ibuilder $appName -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e DB_HOST=$DB_HOST

#clean up
#remove docker network. See https://docs.docker.com/engine/reference/commandline/network_rm/
sudo docker network rm $DB_HOST

#Listing docker network, container and images
sudo docker network ls
sudo docker images
sudo docker ps
