# Base install
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
  && yum -y install yum-utils \
  && yum-config-manager --enable remi-php71
yum update -y
yum -y install glibc-static zlib-devel gcc gcc-c++ make kernel-devel-`uname -r` \
  php \
  php-devel \
  php-mysql \
  php-process \
  php-mcrypt \
  php-mbstring \
  php-gd php-bcmath \
  php-opcache \
  php-apcu \
  php-pecl-xdebug

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install librdkafka
cd /tmp \
  && curl -LO https://github.com/edenhill/librdkafka/archive/v0.9.2.tar.gz && tar xvf v0.9.2.tar.gz \
  && cd librdkafka-0.9.2 && ./configure && make && make install

# Install from source:
cd /tmp \
  && curl -LO https://github.com/arnaud-lb/php-rdkafka/archive/php7.tar.gz && tar xvf php7.tar.gz && cd php-rdkafka-php7/ \
  && phpize && ./configure --with-php-config=/usr/bin/php-config --includedir=/usr/local/include/ && make && make install

# Enable the PHP extension
echo "extension=rdkafka.so" > /etc/php.d/20-rdkafka.ini

sed -i -e 's/^\(ServerRoot.*\)/\1\nServerTokens prod/g' /etc/httpd/conf/httpd.conf
sed -i -e 's/^\(Listen\)/#\1/' /etc/httpd/conf/httpd.conf
sed -i -e 's/^\(DocumentRoot.*\)/# \1/g' /etc/httpd/conf/httpd.conf
