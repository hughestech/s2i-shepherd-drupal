#!/bin/bash
# variables for mysql database
MYSQL_USER=user123
MYSQL_PASSWORD=pass12345678
MYSQL_DATABASE=drupal8
MYSQL_ROOT_PASSWORD=root12345678
DB_HOST=172.22.0.1

#Application Container
appName=hughestech/opensocial

#Mysql hostname. See https://docs.docker.com/engine/reference/commandline/network_create/
docker network create --subnet=172.22.0.0/16 $DB_HOST 

# TODO - add environment variables, using db variables
# https://hub.docker.com/r/centos/mysql-56-centos7/
# NOTE: we do not want the data to be saved across builds, so we are not mapping volumes. This means, the data will be lost when we restart the container. This is the expected result. We only need to mysql so we can run ‘drush install’. 
docker run -d --name mysql_database -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --network=$DB_HOST -p 3306:3306 centos/mysql-56-centos7

# Creating builder image. Not sure if we need to pass env vars here. As long as they are added to dockerfile.
docker build -t drupals2ibuilder . #-e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

# Creating the application image
# Run builder, pass env vars to builder image
s2i build opensocial drupals2ibuilder $appName -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e DB_HOST=$DB_HOST

#clean up
#remove mysql container
docker rm -f mysql_database

#remove docker network. See https://docs.docker.com/engine/reference/commandline/network_rm/
docker network rm $DB_HOST

#Listing docker network, container and images
docker network ls
docker images
docker ps
