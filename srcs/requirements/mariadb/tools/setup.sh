


if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Inizializzazione database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi


mysqld_safe --user=mysql --datadir=/var/lib/mysql &
sleep 5


mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF


pkill mysqld
sleep 2


exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0