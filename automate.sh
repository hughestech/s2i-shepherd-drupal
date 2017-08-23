#!/bin/bash

#Application Container
appName=hughestech/opensocial:1.0.0-alpha1

# Creating builder image. Not sure if we need to pass env vars here. As long as they are added to dockerfile.
docker build -t drupals2ibuilder . #-e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

# Creating the application image
# Run builder, pass env vars to builder image
s2i build opensocial drupals2ibuilder $appName
