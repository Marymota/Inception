#!/bin/sh

set -x

# Checks if the config file has already been created by a previous run of this script
if [ -e /etc/php/8.0/fpm/pool.d/www.conf ]; then
    echo "FastCGI Process Manager config already created"
else
    # Create the directory for www.conf if it doesn't exist
     mkdir -p /etc/php/8.0/fpm/pool.d

    # Substitutes env variables and creates config file
     cat /www.conf.tmpl | /usr/bin/envsubst > /etc/php/8.0/fpm/pool.d/www.conf
     chmod 755 /etc/php/8.0/fpm/pool.d/www.conf
fi

# Checks if wp-config.php file has already been created by a previous run of this script
if [ -e wp-config.php ]; then
	  echo "Wordpress config already created"
else
   wp db export db-backup.sql --socket="/Users/$DB_USER/Library/Application Support/Local/run/Zz3-D-Hl-/mysqld.sock"
    # Create the wordpress config file
   wp config create --allow-root \
       --dbname=$DB_NAME \
       --dbuser=$DB_USER \
       --dbpass=$DB_PASS \
       --dbhost=$DB_HOST

	chmod 777 wp-config.php
fi

# Check if wordpress is already installed
if wp core is-installed --allow-root; then
	  echo "Wordpress core already installed"
else

    # Installs wordpress
   wp core install --allow-root \
       --url='https://mmota.42.fr' \
       --title='Inception' \
       --admin_user=$DB_NAME \
       --admin_email='mmota@42.fr' \
       --admin_password=$DB_PASS

    # create a new author user
   wp user create --allow-root \
       $DB_NAME \
       'mmota@42.fr' \
       --role=author \
       --user_pass=$DB_PASS

    # Turns off debugging which is needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root
fi

# Check if author user has already been created by a previous run of this script
if !(wp user list --field=user_login --allow-root | grep $DB_USER); then

	# create a new author user
    wp user create --allow-root \
        $DB_USER \
        'mmota@42.fr' \
        --role=author \
        --user_pass=$DB_PASS

fi

wp plugin update --all --allow-root

# Sets the correct port to listen to nginx
sed -ie 's/listen = \/run\/php\/php8.0-fpm.sock/listen = 0.0.0.0:9000/g' \
/etc/php/8.0/fpm/pool.d/www.conf

exec "$@"
