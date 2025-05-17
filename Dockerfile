FROM php:8.1-apache

WORKDIR /var/www/html
COPY . .

# Включаем cURL и другие необходимые расширения
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    && docker-php-ext-install curl

# Включаем mod_rewrite для Apache
RUN a2enmod rewrite

# Настраиваем права доступа
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Создаем директорию для хранения данных
RUN mkdir -p /var/www/data
RUN chown -R www-data:www-data /var/www/data
RUN chmod -R 755 /var/www/data

# Переносим порт для Render
ENV PORT=8080
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

EXPOSE ${PORT}
CMD ["apache2-foreground"]