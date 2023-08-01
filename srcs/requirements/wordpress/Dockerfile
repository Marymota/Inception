FROM alpine:3.16

ARG PHP_VERSION=8 \
    DB_NAME \
    DB_USER \
    DB_PASS

RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php-phar \
    wget \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

#RUN addgroup --system wordpress_server \
 # && adduser --system wordpress_server

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

RUN rm -rf * && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --locale=en_GB --allow-root    

COPY ./wordpress/conf/wp-config-create.sh .

RUN  sh wp-config-create.sh && rm wp-config-create.sh && \
     chmod -R 0775 wp-content/

#RUN wp core is-installed --allow-root 
#    wp core install --url=$DB_URLRUN wp core install --url=$DB_URL --title="Inception" --admin_user=$DB_USER --admin_password=$DB_PASS \
#    --admin_email=mmota@42.fr --skip-email --allow-root
#RUN user create $DB_USER $DB_EMAIL --tole=author --user_pass=$DB_PASS --allow-root
#RUN wp theme install astra --activate --allow-root

ENTRYPOINT ["/usr/sbin/php-fpm8", "-F"]
