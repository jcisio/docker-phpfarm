phpfarm for docker
==================

This is a build file to create a [phpfarm](https://github.com/fpoirotte/phpfarm)
setup. The resulting docker image will run Apache on multiple vhosts, each with
different PHP versions accessed via FCGI. The different PHP CLI binaries are
accessible as well.

Then a docker-compose file to reuse other existing images to set up a convenient
environment for Drupal development.

Building the image
------------------

After checkout, simply run the following command:

    docker build -t jcisio/phpfarm:latest -f Dockerfile .

This will setup a Debian base system, install phpfarm, download and compile the
different PHP versions, extensions and setup Apache. So, yes this will take a 
while. See the next section for a faster alternative.

Downloading the image
-----------------

Simply downloading the ready made image from Docker Hub is probably the fastest
way. Just run one of these:

    docker pull jcisio/docker:latest

Loading custom php.ini settings
-------------------------------

All PHP versions are compiled with the config-file-scan-dir pointing to
``/var/www/conf/php/``. When mounting your own project as a volume to
``/var/www/`` you can easily place custom ``.ini`` files there and they should
be automatically be picked up by PHP.

Loading startup script
----------------------

If a script ``/var/www/conf/docker/run.sh`` exists, it will be executed when
the container starts.

Supported PHP extensions
------------------------

Here's a list of the extensions available in each of the PHP versions. It should
cover all the default extensions plus a few popular ones and xdebug for debugging.

Extension    | PHP 5.1 | PHP 5.2 | PHP 5.3 | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1
------------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:
bcmath       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
bz2          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
calendar     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
cgi-fcgi     |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ctype        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
curl         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
date         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
dom          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ereg         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |         |
exif         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
fileinfo     |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
filter       |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ftp          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
gd           |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
gettext      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
hash         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
iconv        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
imap         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
intl         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
json         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ldap         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
libxml       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mbstring     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mcrypt       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mhash        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |         |
mysql        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |         |
mysqli       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mysqlnd      |         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
openssl      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pcntl        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pcre         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo_mysql    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo_pgsql    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo_sqlite   |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pgsql        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
phar         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
posix        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
reflection   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
session      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
simplexml    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
soap         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
sockets      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
spl          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
sqlite       |    ✓    |    ✓    |    ✓    |         |         |         |         |
sqlite3      |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
standard     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
tokenizer    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
wddx         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xdebug       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xml          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xmlreader    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xmlwriter    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xsl          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
zend opcache |         |         |         |         |    ✓    |    ✓    |    ✓    |    ✓
zip          |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
zlib         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓

