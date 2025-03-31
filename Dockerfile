# Use a specific version tag instead of just 8.2-apache for better reproducibility
FROM public.ecr.aws/docker/library/php:8.2.13-apache

# Install system dependencies and PHP extensions in a single RUN to reduce layers
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    libzip-dev \
    nano \
    curl \  
    && docker-php-ext-install \
    zip \
    && a2enmod \
    rewrite \
    headers \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set recommended PHP.ini settings
RUN { \
    echo 'memory_limit = 256M'; \
    echo 'upload_max_filesize = 64M'; \
    echo 'post_max_size = 64M'; \
    echo 'max_execution_time = 600'; \
    echo 'date.timezone = UTC'; \
} > /usr/local/etc/php/conf.d/custom.ini

# Copy Apache configuration first as it changes less frequently
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Create directory for Apache logs
RUN mkdir -p /var/log/apache2 \
    && chown -R www-data:www-data /var/log/apache2

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY ./html/ .

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/healthcheck.php || exit 1

EXPOSE 80

# Use the default Apache command
CMD ["apache2-foreground"]
