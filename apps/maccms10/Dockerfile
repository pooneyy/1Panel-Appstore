From php:8-apache-bookworm
ARG REF master
RUN apt-get update && apt-get install -y \
      git \
      libzip-dev && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure zip && \
    docker-php-ext-install pdo_mysql zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git config --global --add safe.directory /var/www/html && \
    git clone https://github.com/magicblack/maccms10 . && \
    git checkout $REF && \
    rm -rf .git && \
    chmod -R 777 application runtime upload
