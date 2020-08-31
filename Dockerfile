FROM ubuntu:18.04

MAINTAINER Jordan Wamser (jwamser@redpandacoding.com)

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    gnupg \
    curl \
    # Install git
    git \
    # Install apache
    apache2 \
    # Install php 7.2
    libapache2-mod-php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    php-imagick \
    # Install tools
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    # mysql-client \
    iputils-ping \
    locales \
    # sqlite3 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# # install pre requisites
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
RUN apt-get install -y unixodbc-dev

# # dont for get pecl
RUN apt-get -yq install gcc g++ make autoconf libc-dev pkg-config
RUN apt-get install php-pear php-dev -yq

# # install driver sqlsrv
RUN pecl install sqlsrv
# RUN echo "extension=sqlsrv.so" >> /etc/php/7.2/apache2/php.ini
RUN pecl install pdo_sqlsrv
# RUN echo "extension=pdo_sqlsrv.so" >> /etc/php/7.2/apache2/php.ini

# # load driver sqlsrv
RUN echo "extension=/usr/lib/php/20170718/sqlsrv.so" >> /etc/php/7.2/apache2/php.ini
RUN echo "extension=/usr/lib/php/20170718/pdo_sqlsrv.so" >> /etc/php/7.2/apache2/php.ini
RUN echo "extension=/usr/lib/php/20170718/sqlsrv.so" >> /etc/php/7.2/cli/php.ini
RUN echo "extension=/usr/lib/php/20170718/sqlsrv.so" >> /etc/php/7.2/cli/php.ini

# # Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # install ODBC Driver
# RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
# RUN apt-get install -y mssql-tools
# RUN apt-get install -y unixodbc-dev
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN exec bash

# # Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

EXPOSE 80

WORKDIR /var/www/html/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
