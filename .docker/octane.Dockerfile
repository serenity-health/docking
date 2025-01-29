FROM php:8.2-cli

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor \
    nginx \
    wkhtmltopdf 

RUN apt-get install -y libpq-dev 


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions including pgsql and sockets
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd sockets

# Set Composer environment variable
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy project files first
COPY . .
COPY ./.docker/docking-octane.conf /etc/supervisor/conf.d/
COPY ./.docker/docking-host-octane.conf /etc/nginx/conf.d/default.conf


# Run composer install after copying files
RUN composer install --no-dev --optimize-autoloader --no-interaction


# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# Install NPM dependencies and build assets
RUN npm install
RUN npm run build

RUN cp .docker/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

# The bundle already built, no need to keep this to save size
RUN rm -rf ./node_modules

RUN php artisan optimize
RUN php artisan storage:link
RUN ./vendor/bin/rr get-binary
RUN chmod +x ./rr


RUN chown -R www-data:www-data storage
RUN chown -R www-data:www-data storage/app
RUN chmod -R 777 storage/logs

RUN touch /var/www/html/docking.sqlite
RUN chown www-data:www-data docking.sqlite

# Nginx remove default site
RUN rm /etc/nginx/sites-enabled/default

EXPOSE 80 8080

############# Default app ENV
ENV APP_ENV="production"
ENV APP_KEY="base64:/UnGygYvVBmIh+VgNhMj6MyI/ieXTtzUJsUL4OUtZGI="
ENV DB_CONNECTION="pgsql"
ENV DB_HOST="postgres"
ENV DB_PORT="5432"
ENV DB_DATABASE="laravel"
ENV DB_USERNAME="postgres"
ENV DB_PASSWORD="secret"

############# Storage ENV

# s3|local
ENV FILESYSTEM_DISK=public

# if select s3, these must be defined
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION="ap-southeast-1"
ENV AWS_BUCKET="shipsaas-docking"

############# Docking Config
ENV DOCKING_PUBLIC_ACCESS_KEY=""
ENV DOCKING_CONSOLE_ENABLED=true
ENV DOCKING_CONSOLE_PASSWORD=""
ENV DOCKING_DEFAULT_PDF_DRIVER="gotenberg"
ENV DOCKING_GOTENBERG_ENDPOINT="http://127.0.0.1:9898"

# Start ALL
ENTRYPOINT ["/entrypoint"]
