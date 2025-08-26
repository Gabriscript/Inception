#!/bin/bash

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Setting up WordPress..."
    
    wp core download --allow-root
    
    until wp db check --allow-root; do
        echo "Waiting for database connection..."
        sleep 5
    done
    
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --allow-root
    
    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="Inception WordPress" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
    
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root
    
    chown -R www-data:www-data /var/www/html
fi

exec "$@"