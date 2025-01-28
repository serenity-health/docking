# Stage 1: Build stage
FROM php:8.2-fpm AS builder

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \ 
    zip \
    unzip \
    supervisor \
    nginx \
    wkhtmltopdf

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Copy project files
COPY . .

# Optimize Laravel
RUN php artisan optimize
RUN php artisan storage:link

# Set permissions
RUN chown -R www-data:www-data storage
RUN chown -R www-data:www-data storage/app
RUN chmod -R 777 storage/logs

# Remove unnecessary files
RUN rm -rf ./node_modules

# Stage 2: Final stage
FROM php:8.2-fpm

WORKDIR /var/www/html

# Copy only necessary files from the builder stage
COPY --from=builder /var/www/html /var/www/html
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \  
    supervisor \
    nginx \
    wkhtmltopdf \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY ./.docker/docking-worker.conf /etc/supervisor/conf.d/
COPY ./.docker/docking-host.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/php-fpm.conf /usr/local/etc/php-fpm.d/

# Set up entrypoint
COPY .docker/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

# Set up SQLite database
RUN touch /var/www/html/docking.sqlite
RUN chown www-data:www-data docking.sqlite

# Remove default Nginx site
RUN rm /etc/nginx/sites-enabled/default

# Expose port
EXPOSE 80

# Environment variables
ENV APP_ENV="production"
ENV APP_KEY="base64:/UnGygYvVBmIh+VgNhMj6MyI/ieXTtzUJsUL4OUtZGI="
# Default to PostgreSQL
ENV DB_CONNECTION="pgsql"  
# Update with your PostgreSQL credentials
ENV DATABASE_URL="pgsql://user:password@db:5432/database"  
ENV APP_URL="http://127.0.0.1:8000"

# Storage configuration
ENV FILESYSTEM_DISK=public
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION="ap-southeast-1"
ENV AWS_BUCKET="shipsaas-docking"

# Docking configuration
ENV DOCKING_PUBLIC_ACCESS_KEY=""
ENV DOCKING_CONSOLE_ENABLED=true
ENV DOCKING_CONSOLE_PASSWORD=""
ENV DOCKING_DEFAULT_PDF_DRIVER="gotenberg"
ENV DOCKING_GOTENBERG_ENDPOINT="http://127.0.0.1:9898"

# Start all services
ENTRYPOINT ["/entrypoint"]
