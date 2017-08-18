#!/bin/bash
# this script builds everything for docker

if [ -z "$PHP_FARM_VERSIONS" ]; then
    echo "PHP versions not set! Aborting setup" >&2
    exit 1
fi

# build and symlink to major.minor
for VERSION in $PHP_FARM_VERSIONS
do
    cd /phpfarm/src # make absolutely sure we're in the correct directory

    echo "--- compiling version $VERSION -----------------------------------------"

    V=$(echo $VERSION | awk -F. '{print $1"."$2}')

    # compile the PHP version
    ./compile.sh $VERSION
    ln -s "/phpfarm/inst/php-$VERSION/" "/phpfarm/inst/php-$V"
    ln -s "/phpfarm/inst/bin/php-$VERSION" "/phpfarm/inst/bin/php-$V"
    ln -s "/phpfarm/inst/bin/php-cgi-$VERSION" "/phpfarm/inst/bin/php-cgi-$V"
    ln -s "/phpfarm/inst/bin/phpize-$VERSION" "/phpfarm/inst/bin/phpize-$V"
    ln -s "/phpfarm/inst/bin/php-config-$VERSION" "/phpfarm/inst/bin/php-config-$V"

    # compile xdebug
    if [ "$V" == "5.3" ]; then
        XDBGVERSION="XDEBUG_2_2_7" # old release for old PHP versions
    elif [ "$V" == "5.4" ]; then
        XDBGVERSION="XDEBUG_2_4_1" # old release for old PHP versions
    elif [[ $VERSION == *"RC"* ]]; then
        XDBGVERSION="master"       # master for RCs
    else
        XDBGVERSION="XDEBUG_2_5_1" # stable release for all others
    fi

    echo "--- compiling xdebug $XDBGVERSION for php $VERSION ---------------------"

    wget -nv https://github.com/xdebug/xdebug/archive/$XDBGVERSION.tar.gz && \
    tar -xzvf $XDBGVERSION.tar.gz && \
    cd xdebug-$XDBGVERSION && \
    phpize-$V && \
    ./configure --enable-xdebug --with-php-config=/phpfarm/inst/bin/php-config-$V && \
    make && \
    cp -v modules/xdebug.so /phpfarm/inst/php-$V/lib/ && \
    echo "zend_extension_debug = /phpfarm/inst/php-$V/lib/xdebug.so" >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "zend_extension = /phpfarm/inst/php-$V/lib/xdebug.so" >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "[xdebug]" >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "xdebug.remote_enable=1" >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "xdebug.remote_host="`/sbin/ip route|awk '/default/ { print $3 }'` >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "xdebug.max_nesting_level=500" >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "xdebug.idekey = PHPSTORM" >> /phpfarm/inst/php-$V/etc/php.ini && \
    cd .. && \
    rm -rf xdebug-$XDBGVERSION && \
    rm -f $XDBGVERSION.tar.gz
done

# print what have installed
ls -l /phpfarm/inst/bin/

# enable rewriting and templating
a2enmod rewrite macro

# clean up sources
rm -rf /phpfarm/src
apt-get clean autoclean
rm -rf /var/lib/apt/lists/*
