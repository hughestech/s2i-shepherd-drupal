#!/bin/bash
# variables for mysql database
MYSQL_USER=user123
MYSQL_PASSWORD=pass12345678
MYSQL_DATABASE=drupal8
MYSQL_ROOT_PASSWORD=root12345678
DBHOST=172.22.0.1

#Application Container
appName=hughestech/opensocial

#Mysql hostname. See https://docs.docker.com/engine/reference/commandline/network_create/
echo "Creating a network..."
sudo docker network create --subnet=172.22.0.0/16 $DBHOST 
echo

# TODO - add environment variables, using db variables
# https://hub.docker.com/r/centos/mysql-56-centos7/
# NOTE: we do not want the data to be saved across builds, so we are not mapping volumes. This means, the data will be lost when we restart the container. This is the expected result. We only need to mysql so we can run ‘drush install’. 
echo "Creating mysql container..."
sudo docker run -d --name mysql_database -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --network=$DBHOST -p 3306:3306 centos/mysql-56-centos7
echo

#Listing docker network, container and images
echo "Listing docker network, images and containers..."
sudo docker network ls
sudo docker images
sudo docker ps
echo

echo "Accessing docker container..."
sudo docker exec -it mysql_database sh
echo

#echo "Testing if database is working..."
#mysql -h $DBHOST -u user123 -ppass12345678 -e "show databases"
#echo

#mysql -h 172.22.0.1 -u user123 -ppass12345678 -e "show databases"