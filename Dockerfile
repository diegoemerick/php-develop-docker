FROM ubuntu:xenial
MAINTAINER diegoemerick
ENV DEBIAN_FRONTEND=noninteractive

# Install basic
RUN apt-get update
RUN apt-get install wget curl git -y
RUN apt-get install unzip zip -y
RUN apt-get install rubygems ruby-dev -y
RUN apt-get install -y --no-install-recommends apt-utils \
		software-properties-common \
		python-software-properties \
		language-pack-en-base && \
        LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

# Install php 7.1
RUN apt-get update
RUN apt-get install -y \
    php7.1 \
    php7.1-mysql \
    php7.1-mcrypt \
    php7.1-mbstring \
    php7.1-cli \
    php7.1-gd \
    php7.1-curl \
    php7.1-xml \
    php-memcache

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update &&  \
    apt-get install build-essential -y  && \
    apt-get install nodejs -y && \
    ln -s /usr/bin/nodejs /usr/local/bin/node && \
    apt-get clean
RUN npm install -g gulp

# Install compass
RUN gem install compass

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa
# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add bitbuckets key
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

# Install mysql
RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections
RUN apt-get -y install mysql-server

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

