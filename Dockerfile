#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM philcryer/min-jessie:latest

LABEL maintainer = "Nguyen Hai Nam <hainam@jcisio.com>"

# the PHP versions to compile
ENV PHP_FARM_VERSIONS "5.3.29 5.4.45 5.5.38 5.6.31 7.0.21 7.1.7"

# make php 5.3 work again
ENV LDFLAGS "-lssl -lcrypto -lstdc++"

# add some build tools
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    apache2-mpm-prefork \
    autoconf \
    build-essential \
    curl \
    debian-archive-keyring \
    debian-keyring \
    git \
    imagemagick \
    lemon \
    libapache2-mod-fcgid \
    libbz2-dev \
    libc-client2007e-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libkrb5-dev \
    libldap2-dev \
    libltdl-dev \
    libmcrypt-dev \
    libmhash-dev \
    libmysqlclient-dev \
    libpng-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    pkg-config \
    mysql-client \
    vim \
    wget

# install the phpfarm script
RUN git clone https://github.com/jcisio/phpfarm.git -b patch-1 phpfarm

# add customized configuration
COPY phpfarm /phpfarm/src/

# set path
ENV PATH /phpfarm/inst/bin/:/usr/sbin:/usr/bin:/sbin:/bin

# compile, then delete sources (saves space)
RUN cd /phpfarm/src && ./docker.sh

RUN apt-get update && apt-get install sudo
ENV PATH /phpfarm/inst/bin/:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/home/www-data/.composer/vendor/bin:${PATH}
RUN ln -s /phpfarm/inst/bin/php-7.1 /usr/local/bin/php
RUN wget -nv -qO- https://getcomposer.org/installer | php-7.1 -- --install-dir=/usr/local/bin --filename=composer && \
chmod +x /usr/local/bin/composer
RUN mkdir /home/www-data && \
chown www-data.www-data -R /home/www-data && \
usermod -d /home/www-data -s /bin/bash www-data && \
ls -l /home && \
sudo -u www-data composer global require drush/drush

# sendmail for Mailhog
RUN wget -nv https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -O /usr/sbin/mhsendmail

# reconfigure Apache
RUN rm -rf /var/www/*
COPY apache2 /etc/apache2/

RUN a2enmod ssl

# expose the ports
EXPOSE 80 443

# run it
WORKDIR /var/www
COPY run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]
