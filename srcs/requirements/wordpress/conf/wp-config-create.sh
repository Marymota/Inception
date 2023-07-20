#!bin/sh

#Add the followinf PHP code inside wp-config
if [ ! -f "/var/www/wp-config.php" ]; then
cat << EOF > /var/www/wp-config.php

<?php

# DATABASE CONFIG
# Database for WordPress name
define( 'DB_NAME', '${DB_NAME}' );

# MySQL database username
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
