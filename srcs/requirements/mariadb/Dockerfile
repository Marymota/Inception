FROM alpine:3.16

ARG DB_NAME
ARG DB_USER
ARG DB_PASS
ARG DB_ROOT
ARG DB_HOST
ARG DB_MAIL
ARG DB_TITLE
ARG DB_URL
ARG DOMAIN_NAME 

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

RUN mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql 
#RUN mysql_secure_installation --user=mysql --basedir=/usr --datadir=/var/lib/mysql 

EXPOSE 3306

COPY mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh
USER mysql

ENTRYPOINT ["/usr/bin/mysqld", "--skip-log-error"]
