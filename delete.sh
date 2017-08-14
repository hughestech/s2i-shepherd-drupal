#!/bin/bash
# variables for mysql database
DBHOST=172.22.0.1

echo "Deleting mysql container..."
sudo docker rm -f mysql_database
echo

echo "Deleting network..."
sudo docker network rm $DBHOST
echo

#Listing docker network, container and images
echo "Listing docker network, images and containers..."
sudo docker network ls
echo
sudo docker images
echo
sudo docker ps
echo