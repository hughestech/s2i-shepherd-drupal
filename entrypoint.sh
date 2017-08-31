#!/bin/bash
DRUPAL_DIR=/var/www/html

echo "CD to Drupal directory"
cd $DRUPAL_DIR
echo "Checking current directory..."
pwd

if drush status bootstrap | grep -q Successful
then
	echo "Installing Drupal..."
    #drush -y site-install --db-url=mysql://userTY4:2Hi6AIPPRdfP0XLQ@10.128.1.126/drupal
	drush -y -v site-install --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DBHOST}/${MYSQL_DATABASE}
	echo "Lightning is successfully installed."
	drush cr
else
    echo "Installation failed!"
fi
