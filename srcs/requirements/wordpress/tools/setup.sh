#!/bin/sh


echo "Waiting MariaDB..."
while ! nc -z mariadb 3306; do
    sleep 1
done
echo "MariaDB è pronto!"


if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Configurazione WordPress..."
    
   
    wget https://raw.githubusercontent.com/wp-cli/wp-cli/v2.5.0/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    cd /var/www/html
    
  
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --allow-root
    
 
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception WordPress" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
        
    echo "WordPress configurato!"
fi


exec php-fpm81 -F