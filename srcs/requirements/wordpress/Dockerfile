FROM alpine:3.16

ARG PHP_VERSION=8 \
    DB_NAME \
    DB_USER \
    DB_PASS \
    DB_HOST

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
    unzip \
    # 'envsubst' is a utility installed by the 'gettext' package and is used to substitute environment variables in a given template 
    gettext \
    mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /run/php && \ 
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
     /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
     /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
     /etc/php8/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create necessary directories and set permissions
RUN mkdir -p /run/php /var/www/html/wordpress\
    mkdir -p /etc/php${PHP_VERSION}/fpm/pool.d && \
    touch /etc/php${PHP_VERSION}/fpm/pool.d/www.conf

# - add the "wordpress_server" group and user
RUN addgroup --system wordpress_server && \
    adduser --system wordpress_server

COPY ./wordpress/conf/www.conf /www.conf.tmpl

# - Sets the working directory where I want to download wp core
WORKDIR /var/www/html

# - downloads wp core
RUN wp core download --locale=en_GB --allow-root    

# Copy your wp-config-create.sh script to the container
COPY ./wordpress/conf/wp-config-create.sh /usr/local/bin/

# Set the script as executable
RUN chmod +x /usr/local/bin/wp-config-create.sh

RUN rm -f /etc/php/8.0/fpm/pool.d/www.conf

CMD ["/usr/sbin/php-fpm8", "-F"]

ENTRYPOINT ["wp-config-create.sh"]


# Copy the custom php-fpm configuration
#COPY ./wordpress/tools/php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf

# - copy the config file to container root as a template file
#COPY ./wordpress/conf/php-fpm.conf /php-fpm.conf.tmpl


#RUN chmod -R 0775 /usr/local/bin/wp-config-create.sh

# - add the "wordpress_server" group and user
#RUN addgroup --system wordpress_server \
#  && adduser --system wordpress_server


#RUN wp core install --allow-root \
#  --url="https://mmota.42.fr" \
#  --title="Inception" \
#  --admin_user=$DB_USER \
#  --admin_password=$DB_PASS \
#  --admin_email=$DB_EMAIL

#RUN wp core is-installed --allow-root 

#RUN wget https://wordpress.org/latest.zip && \
#    unzip latest.zip && \
#    cp -rf wordpress/* . && \
#    rm -rf wordpress latest.zip


#RUN addgroup --system wordpress_server \
 # && adduser --system wordpress_server

#RUN chmod -R 0775 wp-content/
#COPY ./wordpress/conf/wp-config-create.sh .
#RUN sh wp-config-create.sh

#    wp core install --url=$DB_URLRUN wp core install --url=$DB_URL --title="Inception" --admin_user=$DB_USER --admin_password=$DB_PASS \
#    --admin_email=mmota@42.fr --skip-email --allow-root
#RUN user create $DB_USER $DB_EMAIL --tole=author --user_pass=$DB_PASS --allow-root
#RUN wp theme install astra --activate --allow-root
