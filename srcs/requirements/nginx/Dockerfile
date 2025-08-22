FROM alpine:3.16


RUN apk update && apk add --no-cache \
    nginx \
    openssl


RUN mkdir -p /var/run/nginx \
    /var/www/html \
    /etc/nginx/ssl


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=IT/ST=State/L=City/O=42School/CN=localhost"


COPY conf/nginx.conf /etc/nginx/nginx.conf


EXPOSE 443


CMD ["nginx", "-g", "daemon off;"]