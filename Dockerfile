FROM alpine:3.11

LABEL maintainer="Michael Fayez <michaeleino@hotmail.com>"

RUN apk update && apk upgrade && \
    # Install required packages
    apk add imagemagick \
            ffmpeg \
          	ghostscript \
          	exiftool \
          	antiword \
            xpdf \
            perl-image-exiftool \
            subversion \
          	#poppler-utils \
          	mariadb-client \
            php7-gd \
            php7-dev \
            php7-json \
            php7-mysqli \
            php7-mbstring \
            php7-zip \
            php7-xml \
            php7-dom \
            php7-ldap \
            php7-intl \
            php7-curl \
            php7-fpm \
            php7-exif \
            nginx \
            zip \
            supervisor

ADD ./config /config

RUN mkdir /var/www/resourcespace && cd /var/www/resourcespace && \
    svn co https://svn.resourcespace.com/svn/rs/releases/9.1 . && \
    #mkdir filestore && \
    #chmod 777 filestore && \
    chmod -R 750 include && \
    chown -R nginx:www-data /var/www/resourcespace && \
    #create needed dirs
    mkdir /run/php7 /run/nginx && \
    ## replace to enable php-fpm socket and set permission
    sed -i 's/^listen = 127.0.0.1:9000/\;listen = 127.0.0.1:9000\nlisten\=\/run\/php7\/php-fpm.sock\nlisten.owner=nginx\nlisten.group=www-data\nlisten.mode=0660/g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's/^user = nobody/user = nginx/g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's/^group = nobody/group = www-data/g' /etc/php7/php-fpm.d/www.conf && \
    ## remove default nginx vhost
    rm /etc/nginx/conf.d/default.conf && \
    ## add supervisord dir
    mv /config/supervisor.d /etc/ && \
    mv /config/rs-nginx.conf /etc/nginx/conf.d/ && \
    mv /config/php.ini /etc/php7/conf.d/ && \
    rm -r /config

#VOLUME ["/var/www/resourcespace/filestore"]
VOLUME ["/var/log/"]
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
