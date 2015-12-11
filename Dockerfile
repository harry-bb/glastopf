# Glastopf Dockerfile by MO 
#
# VERSION 16.03.1
FROM ubuntu:14.04.3
MAINTAINER MO 

# Setup apt
RUN apt-get update -y
RUN apt-get dist-upgrade -y
ENV DEBIAN_FRONTEND noninteractive

# Install packages 
RUN apt-get install -y python2.7 python-openssl python-gevent libevent-dev python2.7-dev build-essential make \
python-chardet python-requests python-sqlalchemy python-lxml \
python-beautifulsoup python-pip python-dev python-setuptools \
g++ git php5 php5-dev liblapack-dev gfortran libmysqlclient-dev \
libxml2-dev libxslt-dev supervisor

# Install php sandbox from git
RUN git clone https://github.com/glastopf/BFR.git /opt/BFR
RUN cd /opt/BFR && phpize && ./configure --enable-bfr && make && make install
RUN echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php5/apache2/php.ini
RUN echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php5/cli/php.ini

# Install glastopf from git
RUN git clone https://github.com/mushorg/glastopf.git /opt/glastopf
RUN cd /opt/glastopf && python setup.py install

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot 
RUN adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot 
RUN mkdir -p /data/glastopf/
ADD glastopf.cfg /data/glastopf/
RUN chmod 760 -R /data/ && chown tpot:tpot -R /data/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup ewsposter
RUN apt-get install -y python-mysqldb python-requests
RUN git clone https://github.com/rep/hpfeeds.git /opt/hpfeeds && cd /opt/hpfeeds && python setup.py install && \
git clone https://github.com/armedpot/ewsposter.git /opt/ewsposter
RUN mkdir -p /opt/ewsposter/spool /opt/ewsposter/log

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set workdir and start glastopf
WORKDIR /data/glastopf/
CMD ["/usr/bin/supervisord"]

