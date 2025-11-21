From php:8.5-apache-bookworm
ARG REF main
RUN apt-get update && apt-get install -y \
      git \
      libfreetype6-dev \
      libjpeg-dev \
      libpng-dev \
      libwebp-dev \
      libzip-dev \
      zlib1g-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure zip && \
    docker-php-ext-install gd pdo_mysql zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git config --global --add safe.directory /var/www/html && \
    git clone https://github.com/lizhipay/acg-faka . && \
    git checkout $REF && \
    rm -rf .git && \
    a2enmod rewrite