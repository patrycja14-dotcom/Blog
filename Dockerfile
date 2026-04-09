FROM php:8.0-cli

# Instalacja zależności systemowych (WAŻNE: libpq-dev dla Postgresa)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# Instalacja Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Ustawienie katalogu roboczego
WORKDIR /var/www

# Kopiowanie projektu
COPY . .

# Instalacja zależności Laravel
RUN composer install --no-dev --optimize-autoloader --no-scripts \
    && composer require laravel/ui --no-interaction

# Uprawnienia (Laravel tego potrzebuje)
RUN chmod -R 775 storage bootstrap/cache

# Port dla Render
EXPOSE 10000

# Start aplikacji
CMD php artisan serve --host=0.0.0.0 --port=10000