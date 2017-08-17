#!/bin/bash
DRUPAL_DIR=/var/www/html

echo "CD to Drupal directory"
cd $DRUPAL_DIR
	echo "Checking current directory..."
	pwd
    # drush -y site-install --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DRUPAL_SERVICE_NAME}-db/$MYSQL_DATABASE -r $DRUPAL_DIR
    echo "Install Drupal"
    #drush -y site-install --db-url=mysql://userTY4:2Hi6AIPPRdfP0XLQ@10.128.1.126/drupal
    echo "Running drush install..."
	drush -y -v site-install --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DBHOST}/${MYSQL_DATABASE}
	echo "OpenSocial site is successfully installed."
	drush cr

