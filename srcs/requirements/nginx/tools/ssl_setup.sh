#!/bin/bash

#!/bin/bash

# Crea directory SSL se non esistono
mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Generating SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=IT/ST=Italy/L=Rome/O=42/CN=${DOMAIN_NAME:-localhost}"
fi

echo "SSL setup completed. Starting Nginx..."
exec nginx -g "daemon off;"
