FROM php:8.2-apache
RUN apt-get update	
RUN apt install -y apt-utils	
# Install dependencies	
# Step 4 (updated): Add libzip-dev and libssl-dev
RUN apt-get install -qq -y \
    curl \
    git \
    zlib1g-dev \
    libzip-dev \
    zip unzip \
    libssl-dev

# Step 5 (updated): Add default-mysql-client/libmysqlclient-dev

RUN apt-get update && apt-get install -y \
    libonig-dev \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev \
    libfreetype6-dev \
    default-mysql-client \
	libmariadb-dev-compat \
    libmariadb-dev
	
RUN apt-get install -y libjpeg-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev	
RUN docker-php-ext-configure gd --with-freetype --with-jpeg	
# Clear cache	
RUN apt-get clean && rm -rf /var/lib/apt/lists/*	
# Install PHP extensions     	
RUN docker-php-ext-install \
    bcmath \
    pdo_mysql \
    pcntl \
    zip \
    xml \
    intl \
    exif \
    gd
# Install composer	
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer	
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN a2enmod rewrite
USER www-data