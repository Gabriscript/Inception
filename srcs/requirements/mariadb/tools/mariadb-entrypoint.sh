#!/bin/bash
set -e

# Configure server to listen on all interfaces (first run only)
if [ ! -f /etc/.firstrun ]; then
    cat << EOF >> /etc/my.cnf.d/mariadb-server.cnf
[mysqld]
bind-address=0.0.0.0
skip-networking=0
EOF
    touch /etc/.firstrun
fi

# Initialize database directory on first mount
if [ ! -f /var/lib/mysql/.firstmount ]; then
    echo "Initializing database directory..."
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db \
        --user=mysql --group=mysql >/dev/null 2>&1

    # Start MariaDB in background to perform initial setup
    mysqld_safe --skip-networking=0 --socket=/tmp/mysql.sock &
    pid="$!"

    echo "Waiting for MariaDB to accept connections..."
    until mysqladmin ping --socket=/tmp/mysql.sock --silent >/dev/null 2>&1; do
        sleep 1
    done
    echo "MariaDB is up, running initial SQL setup..."

    mysql --socket=/tmp/mysql.sock -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
EOSQL

    echo "Shutting down temporary MariaDB server..."
    mysqladmin --socket=/tmp/mysql.sock -u root -p${MYSQL_ROOT_PASSWORD} shutdown || true

    touch /var/lib/mysql/.firstmount
    echo "Database initialization finished."
fi

# Start MariaDB in foreground
echo "Starting MariaDB in foreground..."
exec mysqld_safe

