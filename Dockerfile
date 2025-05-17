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

# Создание конфигурации Apache
RUN echo '<VirtualHost *:10000>
    ServerName localhost
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Настройка порта Apache
RUN echo 'Listen 10000' > /etc/apache2/ports.conf

# Создание индексного файла
RUN echo '<?php header("Location: deab0093a0f4551414b49ba57151ae08.php"); ?>' > /var/www/html/index.php

# Копирование файлов в директорию Apache
RUN cp *.php /var/www/html/
RUN cp *.html /var/www/html/
RUN cp *.js /var/www/html/
COPY .htaccess /var/www/html/.htaccess

# Настройка прав доступа
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Директория для сохранения данных
RUN mkdir -p /var/www/data
RUN chown -R www-data:www-data /var/www/data
RUN chmod -R 777 /var/www/data

# Скрипт запуска для обоих сервисов
RUN echo '#!/bin/bash\n\
service apache2 start\n\
node server.js\n\
' > /start.sh

RUN chmod +x /start.sh

# Порты для Node.js и Apache
EXPOSE 3000 10000

# Запуск обоих сервисов
CMD ["/start.sh"]
