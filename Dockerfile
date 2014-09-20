FROM phusion/baseimage:0.9.13
MAINTAINER Dennis Møllegaard Pedersen <dennis@moellegaard.dk>
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get update && apt-get install -y apache2 
RUN apt-get install -y php5 php-pear php5-mysql
RUN apt-get install -y php5-mcrypt php5-intl
RUN sed -i -e "s/^;date\.timezone =.*$/date\.timezone = 'UTC'/" /etc/php5/apache2/php.ini
RUN rm /var/www/html/index.html
RUN rmdir /var/www/html
ADD roundcubemail-1.0-rc.tar.gz /tmp
RUN mv /tmp/roundcubemail-1.0-rc  /var/www/html
RUN rm -rf /tmp/roundcubemail-1.0-rc
RUN chown -R www-data:nogroup /var/www/html
RUN chmod o+w /var/www/html/temp
RUN chmod o+w /var/www/html/logs
ADD config.inc.php /var/www/html/config/config.inc.php

RUN chmod 755 /etc/container_environment
RUN chmod 644 /etc/container_environment.sh /etc/container_environment.json

RUN mkdir /etc/service/apache/
ADD apache.sh /etc/service/apache/run

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
