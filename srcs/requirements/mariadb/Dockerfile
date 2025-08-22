FROM alpine:3.16


RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client


RUN mkdir -p /var/lib/mysql \
    /run/mysqld


RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld


COPY tools/setup.sh /setup.sh


COPY conf/my.cnf /etc/mysql/my.cnf

RUN chmod +x /setup.sh


EXPOSE 3306


CMD ["/setup.sh"]