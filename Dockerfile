FROM php:8.2-apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./html/ /var/www/html/
RUN a2enmod rewrite
