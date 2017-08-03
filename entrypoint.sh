#!/bin/bash

echo "Installation starting..."

echo "CD to Drupal directory"
cd $DRUPAL_DIR
	echo "Checking current directory..."
	pwd
    # drush -y site-install --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DRUPAL_SERVICE_NAME}-db/$MYSQL_DATABASE -r $DRUPAL_DIR
    echo "Install Drupal"
    drush -y site-install --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DRUPAL_SERVICE_NAME}-db/$MYSQL_DATABASE
    echo "Drupal Installed"

