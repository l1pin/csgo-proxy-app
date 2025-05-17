FROM node:16-bullseye

# Установка PHP и Apache
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-curl \
    libapache2-mod-php \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Включение mod_rewrite для Apache
RUN a2enmod rewrite

# Копирование файлов приложения
WORKDIR /app
COPY . .

# Установка зависимостей Node.js
RUN npm install

# Настройка Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/ports.conf

# Настройка прав доступа
RUN mkdir -p /var/www/html && \
    cp *.php /var/www/html/ || true && \
    cp *.html /var/www/html/ || true && \
    cp *.js /var/www/html/ || true && \
    cp .htaccess /var/www/html/ || true && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    mkdir -p /var/www/data && \
    chown -R www-data:www-data /var/www/data && \
    chmod -R 777 /var/www/data

# Создание скрипта запуска для обоих сервисов
RUN echo '#!/bin/bash\nservice apache2 start\nnode server.js' > /start.sh && \
    chmod +x /start.sh

# Порты для Node.js и Apache
EXPOSE 3000 8080

# Запуск обоих сервисов
CMD ["/start.sh"]
