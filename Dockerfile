# @todo Upgrade to latest 16.04.
FROM ubuntu:xenial-20170119

MAINTAINER Casey Fulton <casey.fulton@adelaide.edu.au>

LABEL io.k8s.description="Platform for serving Drupal PHP apps in Shepherd" \
      io.k8s.display-name="Shepherd Drupal" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,shepherd,drupal,php,apache" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"

ENV DEBIAN_FRONTEND noninteractive

# Configured timezone.
ENV TZ=Australia/Adelaide
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Ensure UTF-8.
RUN locale-gen en_AU.UTF-8
ENV LANG       en_AU.UTF-8
ENV LC_ALL     en_AU.UTF-8

# Upgrade all currently installed packages and install web server packages.
RUN apt-get update \
&& apt-get -y install software-properties-common python-software-properties \
&& add-apt-repository -y ppa:ondrej/php && apt-get update \
&& apt-get -y dist-upgrade \
&& apt-get -y install apache2 php-common libapache2-mod-php mysql-client php-apcu php-bcmath php-cli php-curl php-gd php-ldap php-memcached php-mysql php7.1-opcache php-mbstring php-soap php-xml php-zip git libedit-dev ssmtp wget \
&& apt-get -y remove --purge software-properties-common python-software-properties \
&& apt-get -y autoremove && apt-get -y autoclean && apt-get clean && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/*

# Adding user node
RUN adduser node root

# Install Drupal tools: Robo, Drush, Drupal console and Composer.
RUN wget -O /usr/local/bin/robo https://github.com/consolidation/Robo/releases/download/1.0.4/robo.phar && chmod +x /usr/local/bin/robo \
&& wget -O /usr/local/bin/drush https://s3.amazonaws.com/files.drush.org/drush.phar && chmod a+x /usr/local/bin/drush \
&& wget -O /usr/local/bin/drupal https://drupalconsole.com/installer && chmod a+x /usr/local/bin/drupal \
&& wget -q https://getcomposer.org/installer -O - | php -- --install-dir=/usr/local/bin --filename=composer

# Make bash the default shell.
RUN ln -sf /bin/bash /bin/sh

# Apache config.
COPY ./files/apache2.conf /etc/apache2/apache2.conf

# Startup config
COPY ./entrypoint.sh /var/www/entrypoint.sh

# PHP config.
COPY ./files/php_custom.ini /etc/php/7.1/mods-available/php_custom.ini

# Configure apache modules, php modules, logging.
RUN a2enmod rewrite \
&& a2dismod vhost_alias \
&& a2disconf other-vhosts-access-log \
&& a2dissite 000-default \
&& phpenmod -v ALL -s ALL php_custom

# Add /code /shared directories and ensure ownership by User 33 (www-data) and Group 0 (root).
RUN mkdir -p /code /shared /var/www

# Add in bootstrap script.
COPY ./files/apache2-foreground /apache2-foreground
RUN chmod +x /apache2-foreground

# Add s2i scripts.
COPY ./s2i/bin /usr/local/s2i
RUN chmod +x /usr/local/s2i/*
ENV PATH "$PATH:/usr/local/s2i"

# Web port.
EXPOSE 8080

# Set working directory.
WORKDIR /var/www

# Change all ownership to User 33 (www-data) and Group 0 (root).
RUN chown -R node:root   /var/www \
&&  chown -R node:root   /run/lock \
&&  chown -R node:root   /var/run/apache2 \
&&  chown -R node:root   /var/log/apache2 \
&&  chown -R node:root   /code \
&&  chown -R node:root   /shared \
&&  chown -R node:root   /tmp \
&&  chown -R node:root   /var

RUN chmod -R g+rw  /var/www \
&&  chmod -R g+rw  /run/lock \
&&  chmod -R g+rw  /var/run/apache2 \
&&  chmod -R g+rw  /var/log/apache2 \
&&  chmod -R g+rw  /code \
&&  chmod -R g+rw  /shared \
&&  chmod -R g+rw  /tmp \
&&  chmod -R g+rw  /var


# Change the homedir of www-data to be /code.
#RUN usermod -d /code www-data
#RUN usermod -d /var/www www-data

USER 1000

# Start the web server.
CMD ["/apache2-foreground"]
