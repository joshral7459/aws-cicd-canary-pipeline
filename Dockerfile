FROM php:8.2-apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./html/ /var/www/html/
RUN a2enmod rewrite

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    libzip-dev \
    nano \
    && docker-php-ext-install zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable PHP modules and Apache modules
RUN a2enmod php7 rewrite headers

EXPOSE 80
