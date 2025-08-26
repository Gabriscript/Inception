#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    
    chown -R mysql:mysql /var/lib/mysql
    
    mysqld_safe --user=mysql &
    
    until mysqladmin ping >/dev/null 2>&1; do
        echo "Waiting for MariaDB to start..."
        sleep 2
    done
    
    echo "Setting up database and users..."
    
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"
    
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
fi

chown -R mysql:mysql /var/lib/mysql

exec "$@"