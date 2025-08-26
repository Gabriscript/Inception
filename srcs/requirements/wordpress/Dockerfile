FROM wordpress:6.4-php8.2-fpm

# Forzo php-fpm ad ascoltare su TCP invece che su socket
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /usr/local/etc/php-fpm.d/www.conf \
 && sed -i 's|^listen = .*|; disabled by custom Dockerfile|' /usr/local/etc/php-fpm.d/zz-docker.conf

