FROM nginx:1.18

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ssl_setup.sh /usr/local/bin/ssl_setup.sh
RUN chmod +x /usr/local/bin/ssl_setup.sh

RUN mkdir -p /etc/nginx/ssl

# Genera i certificati durante il build
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=IT/ST=Italy/L=Rome/O=42/CN=localhost"

CMD ["nginx", "-g", "daemon off;"]
