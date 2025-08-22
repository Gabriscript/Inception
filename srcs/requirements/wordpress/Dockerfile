FROM alpine:3.16


RUN apk update && apk add --no-cache \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-json \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-mbstring \
    php81-openssl \
    php81-xml \
    php81-zip \
    php81-redis \
    wget \
    unzip


RUN mkdir -p /var/www/html \
    /run/php


RUN wget https://wordpress.org/latest.tar.gz -P /tmp \
    && tar -xzf /tmp/latest.tar.gz -C /tmp \
    && cp -r /tmp/wordpress/* /var/www/html/ \
    && rm -rf /tmp/wordpress /tmp/latest.tar.gz


COPY conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh


RUN chown -R nobody:nobody /var/www/html


EXPOSE 9000

CMD ["/setup.sh"]