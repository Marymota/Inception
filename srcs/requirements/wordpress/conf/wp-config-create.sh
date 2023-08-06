#!/bin/sh

set -x

#until mysql --host=mariadb --user=root --password=${DB_PASS} -e '\c'; do
#  echo >&2 "mariadb is unavailable - sleeping"
#  sleep 1
#done

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
# Apline don't have mariadb-server package so this configurations need to be made manually
# https://bestafiko.medium.com/cant-connect-to-local-mysql-server-through-socket-var-run-mysqld-mysqld-sock-2-on-docker-c854638cd2db
#    touch /var/run/mysqld/mysqld.sock
#    touch /var/run/mysqld/mysqld.pid
#    chown -R mysql:mysql /var/run/mysqld/mysqld.sock
#    chown -R mysql:mysql /var/run/mysqld/mysqld.pid
#    chmod -R 644 /var/run/mysqld/mysqld.sock

    # Create the wordpress config file
   wp config create --allow-root \
       --dbname=wordpress \
       --dbuser=mmota \
       --dbpass=10taCruel \
       --dbhost=mariadb

	chmod 777 wp-config.php
fi

# Check if wordpress is already installed
if wp core is-installed --allow-root; then
	  echo "Wordpress core already installed"
else

    # Installs wordpress
   wp core install --allow-root \
       --url=https://mmota.42.fr \
       --title=Inception \
       --admin_user=mmota \
       --admin_email=mmota@42.fr \
       --admin_password=10taCruel

    # create a new author user
   wp user create --allow-root \
       mmota \
       mmota@42.fr \
       --role=author \
       --user_pass=10taCruel

    # Turns off debugging which is needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root
fi

# Check if author user has already been created by a previous run of this script
if !(wp user list --field=user_login --allow-root | grep mmota); then

	# create a new author user
    wp user create --allow-root \
        mmota \
        mmota@42.fr \
        --role=author \
        --user_pass=10taCruel

fi

wp plugin update --all --allow-root

# Sets the correct port to listen to nginx
sed -ie 's/listen = \/run\/php\/php8.0-fpm.sock/listen = 0.0.0.0:9000/g' \
/etc/php/8.0/fpm/pool.d/www.conf

exec "$@"
