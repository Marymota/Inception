!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then

    #Solved Fatal error: Can't open and lock privilege tables
    chown -R mysql:mysql /var/lib/mysql
#    chgrp -R mysql /var/lib/mysql

    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql --rpm
     
    tfile='mktemp'
    if [ ! -f "$tfile" ]; then
		return 1
    fi
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then
    cat <<EOF > /tmp/create_db.sql

# Switch to mysql database
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# Create a new root user
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
ALTER USER 'mysql'@'localhost' IDENTIFIED BY '${DB_ROOT}';

# Create a MySQL database for WordPress
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;

# Create MySQL users and set passwords
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';

# Grant all privileges on the WordPress database to the users
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

#service mysql stop

    # Run the initialization SQL script (init.sql)
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
    rm -f /tmp/create_db.sql
fi
