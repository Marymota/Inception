NGINX PHP-FPM Configuration Steps
1. Install PHP-FPM
	-> ./wordpress -> Dockerfile 
	$ apk add php php8-fpm

2. Solve socket error (was not necessary after all)
	-> ./wordpress/conf -> wp-config-create.sh
# Apline don't have mariadb-server package so this configurations need to be made manually
$ https://bestafiko.medium.com/cant-connect-to-local-mysql-server-through-socket-var-run-mysqld-mysqld-sock-2-on-docker-c854638cd2db
$    touch /var/run/mysqld/mysqld.sock
$    touch /var/run/mysqld/mysqld.pid
$    chown -R mysql:mysql /var/run/mysqld/mysqld.sock
$    chown -R mysql:mysql /var/run/mysqld/mysqld.pid
$    chmod -R 644 /var/run/mysqld/mysqld.sock
 

Resources:
https://www.digitalocean.com/community/tutorials/php-fpm-nginx#nginx-php-fpm-configuration-steps
