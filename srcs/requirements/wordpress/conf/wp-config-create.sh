#!bin/sh

#Add the followinf PHP code inside wp-config
if [ ! -f "/var/www/wp-config.php" ]; then
cat << EOF > /var/www/wp-config.php

<?php

# DATABASE CONFIG
# Database for WordPress name
define( 'DB_NAME', '${DB_NAME}' );

define( 'DB_USER', '${DB_USER}' );

# MySQL database password
define( 'DB_PASSWORD', '${DB_PASS}' );

# MySQL hostname
define( 'DB_HOST', 'mariadb' );

# Database Charset in creating database tables
define( 'DB_CHARSET', 'utf8' );

# Database Collate type (sorting rules, case and sensitivity properties)
define( 'DB_COLLATE', '' );

# DEBUG MODE
# Enable debug mode 
define( 'WP_DEBUG', true );

# Force WP to store messages into debug.log 
define( 'WP_DEBUG_LOG', true );

# Hide debug logs from the screen
define( 'WP_DEBUG_DISPLAY', false );

# Don't print errors on screen
@ini_set( 'display_errors', 0 );

# PREDEFINED WORDPRESS CONSTANTS*/
# Writes files directly to the filesystem
define('FS_METHOD','direct');

# WP Database table prefix
\$table_prefix = 'wp_';

# Checks if wp-config.php file has already been created by a previous run of this script
if [ -e wp-config.php ]; then
	  echo "Wordpress config already created"
else
    # Create the wordpress config file
    wp config create --allow-root \
        --dbname=$db_name \
        --dbuser=$db_user \
        --dbpass=$db_pwd \
        --dbhost=$db_host
   chmod 600 wp-config.php
fi

# Check if wordpress is already installed
if wp core is-installed --allow-root; then
	  echo "Wordpress core already installed"
else
    # Installs wordpress
    wp core install --allow-root \
        --url=https://mmota.42.fr \
        --title="Inception" \
        --admin_user=$DB_USER \
        --admin_email=mmota@42.fr \
        --admin_password=$DB_PASS

    wp user create --allow-root \
        $DB_USER \
        mmota@42.fr \
        --role=author \
        --user_pass=$DB_PASS

    # Turns off debugging which is needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root
fi

# Check if author user has already been created by a previous run of this script
if !(wp user list --field=user_login --allow-root | grep $DB_USER); then
	# Create a new author user
    wp user create --allow-root \
        $DB_USER \
        mmota@42.fr \
        --role=author \
        --user_pass=$DB_PASS
fi

wp user set-role $DB_USER administrator --allow-root

wp plugin update --all --allow-root

# Set comment settings

wp option set comment_moderation 0 --allow-root
wp option set moderation_notify 0 --allow-root
wp option set comment_previously_approved 0 --allow-root
wp option set close_comments_for_old_posts 0 --allow-root   
wp option set close_comments_days_old 0 --allow-root

# Sets the correct port to listen to nginx
sed -ie 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' \
/etc/php/7.4/fpm/pool.d/www.conf

wp theme activate twentytwentytwo --allow-root

chown -R wpg:wpg /var/www/html*

# Absolute path to the WP directory 
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

# Sets up WP vars and include files
require_once ABSPATH . 'wp-settings.php';
EOF
fi

