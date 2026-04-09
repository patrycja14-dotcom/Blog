FROM php:8.0-cli

# Instalacja zależności systemowych
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip

# Instalacja rozszerzeń PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Instalacja Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Ustaw katalog roboczy
WORKDIR /var/www

# Kopiuj pliki projektu
COPY . .

# Instaluj zależności Laravel
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Uprawnienia (Laravel potrzebuje)
RUN chmod -R 775 storage bootstrap/cache

# Port (Render używa zmiennej PORT)
EXPOSE 10000

# Start aplikacji
CMD php artisan serve --host=0.0.0.0 --port=10000