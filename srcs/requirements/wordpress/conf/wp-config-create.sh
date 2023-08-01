#!bin/sh

#Add the followinf PHP code inside wp-config
if [ ! -f "/var/www/html/wp-config.php" ]; then
	cat << EOF > /var/www/html/wp-config.php

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

# Absolute path to the WP directory 
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

# Sets up WP vars and include files
require_once ABSPATH . 'wp-settings.php';
EOF
fi

#if [ -e /etc/php/8.0/fpm/pool.d/www.conf ]; then
#	echo "FastCGI Process Manager config already created"
#else

# Ensure the necessary directories exist
#	mkdir -p /etc/php/8.0/fpm/pool.d/
#	# Create www.conf
#	cat > /etc/php/8.0/fpm/pool.d/www.conf <<EOL
#	[www]
#	user = www-data
#	group = www-data
#	listen = /run/php/php8.0-fpm.sock
#	listen.owner = www-data
#	listen.group = www-data
#	pm = dynamic
#	pm.max_children = 5
#	pm.start_servers = 2
#	pm.min_spare_servers = 1
#	pm.max_spare_servers = 3
#	EOL

	# Set appropriate permissions for www.conf
#	chmod 644 /etc/php/8.0/fpm/pool.d/www.conf
#fi

#wp core install --url=$DB_URL --title=$DB_TITLE --admin_user=$DB_USER --admin_password=$DB_PASS --admin_email=$DB_EMAIL

#if ! wp core is-installed --allow-root; then
#	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS
#	# create admin
#	wp core install --allow-root \
#	--url=$DB_URL \
#	--title="Inception" \
#	--admin_user=mmota \
#	--admin_password=$DB_PASS \
#	--admin_email=mmota@42.fr \
#	#create user
#	wp user create --allow-root \
#		$DB_USER \
#		$DB_EMAIL \
#		--role=author \
#		--user_pass=$WP_PASS
#	wp core install --url=$DB_URL --title=$DB_TITLE --admin_user=$DB_USER --admin_password=$DB_PASS --admin_email=$DB_EMAIL
#fi
