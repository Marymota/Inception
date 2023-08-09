FROM alpine:3.16

ARG PHP_VERSION=8

RUN apk update && apk upgrade && apk add --no-cache \
    # Instal PHP-FPM & other packages
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
    unzip \
    # 'envsubst' is a utility installed by the 'gettext' package and is used to substitute environment variables in a given template 
    gettext \
    mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apk/* 

RUN sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" /etc/php8/php-fpm.d/www.conf 

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Sets the working directory
WORKDIR /var/www/html/wordpress

# Download wp core
RUN wp core download --locale=en_GB --allow-root    

# Copy your wp-config-create.sh script to the container
COPY ./wordpress/conf/wp-config-create.sh /usr/local/bin/

# Set the script as executable
RUN chmod +x /usr/local/bin/wp-config-create.sh

EXPOSE 9000

CMD ["/usr/sbin/php-fpm8", "-F"]

ENTRYPOINT ["wp-config-create.sh"]
