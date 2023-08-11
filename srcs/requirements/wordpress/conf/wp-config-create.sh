#!/bin/sh

set -x

# Checks if wp-config.php file has already been created by a previous run of this script
if [ -e wp-config.php ]; then
	  echo "Wordpress config already created"
else

    # Create the wordpress config file
   wp config create --allow-root \
       --dbname=${DB_NAME} \
       --dbuser=${DB_USER} \
       --dbpass=${DB_PASS} \
       --dbhost=${DB_HOST}

	chmod 777 wp-config.php
fi

# Check if wordpress is already installed
if wp core is-installed --allow-root; then
	  echo "Wordpress core already installed"
else

    # Installs wordpress
   wp core install --allow-root \
       --url=https://${DOMAIN_NAME} \
       --title=${DB_TITLE} \
       --admin_user=${DB_USER} \
       --admin_email=${DB_MAIL} \
       --admin_password=${DB_PASS}

    # create a new author user
   wp user create --allow-root \
       ${WP_USER} \
       ${WP_MAIL} \
       --role=author \
       --user_pass=${WP_PASS}

    # Turns off debugging which is needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root
fi

# Check if author user has already been created by a previous run of this script
if !(wp user list --field=user_login --allow-root | grep ${DB_NAME}); then

	# create a new author user
    wp user create --allow-root \
        ${WP_USER} \
        ${WP_MAIL} \
        --role=author \
        --user_pass=${WP_PASS}

fi

wp plugin update --all --allow-root

exec "$@"
