# Glastopf Dockerfile by MO 
#
# VERSION 16.03.3
FROM ubuntu:14.04.4
MAINTAINER MO 

# Setup apt
RUN apt-get update -y && \
    apt-get dist-upgrade -y
ENV DEBIAN_FRONTEND noninteractive

# Install packages 
RUN apt-get install -y python2.7 python-openssl python-gevent libevent-dev python2.7-dev build-essential make \
    python-chardet python-requests python-sqlalchemy python-lxml \
    python-beautifulsoup python-pip python-dev python-setuptools \
    g++ git php5 php5-dev liblapack-dev gfortran libmysqlclient-dev \
    libxml2-dev libxslt-dev supervisor

# Install php sandbox from git
RUN git clone https://github.com/glastopf/BFR.git /opt/BFR && \
    cd /opt/BFR && phpize && ./configure --enable-bfr && make && make install && \
    echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php5/apache2/php.ini && \
    echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php5/cli/php.ini

# Install glastopf from git
RUN git clone https://github.com/mushorg/glastopf.git /opt/glastopf && \
    cd /opt/glastopf && python setup.py install

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot
ADD glastopf.cfg /opt/glastopf/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup ewsposter
RUN apt-get install -y python-mysqldb python-requests && \
    git clone https://github.com/rep/hpfeeds.git /opt/hpfeeds && cd /opt/hpfeeds && python setup.py install && \
    git clone https://github.com/armedpot/ewsposter.git /opt/ewsposter && \
    mkdir -p /opt/ewsposter/spool /opt/ewsposter/log

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set workdir and start glastopf
WORKDIR /data/glastopf/
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
