#/bin/bash

# is a certain UID wanted?
if [ ! -z "$APACHE_UID" ]; then
    useradd --home /var/www --gid www-data -M -N --uid $APACHE_UID  wwwrun
    echo "export APACHE_RUN_USER=wwwrun" >> /etc/apache2/envvars
    chown -R wwwrun /var/lib/apache2
fi

if [ -e /var/www/conf/docker/run.sh ]; then
  /var/www/conf/docker/run.sh
fi

apache2ctl start
tail -f /var/log/apache2/error.log
