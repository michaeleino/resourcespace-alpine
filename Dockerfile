FROM alpine:3.12
ARG RSVER=9.5
# ARG UNO_URL=https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv

LABEL maintainer="Michael Fayez <michaeleino@hotmail.com>"
    #add egde repositories
RUN echo -e "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing\\n@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    #update and upgrade
    apk update && apk upgrade && \
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
            php7-phar \
            nginx \
            zip \
            supervisor \
            ## add unoconv requirements
            curl \
            util-linux \
            libreoffice-common \
            libreoffice-writer \
            ttf-droid-nonlatin \
            ttf-droid \
            ttf-dejavu \
            ttf-freefont \
            ttf-liberation \
            openexr@edgecommunity \
            hdf5@edgecommunity \
            opencv@testing \
            py3-unoconv@testing
            # && \
## install openoffice unoconv --> https://hub.docker.com/r/sfoxdev/unoconv-alpine/dockerfile
    # curl -Ls $UNO_URL -o /usr/local/bin/unoconv && \
    # chmod +x /usr/local/bin/unoconv && \
    # ln -s /usr/bin/python3 /usr/bin/python && \
##TO DO
### python3
### install OpenCV --> https://pypi.org/project/opencv-python/
### pip install opencv-python
##
    # echo 'manylinux1_compatible = True' > /usr/lib/python3.8/site-packages/_manylinux.py && \
    # python -c 'import sys; sys.path.append(r"/_manylinux.py")' && \
    # pip3 install opencv-python

ADD ./config /config

RUN mkdir /var/www/resourcespace && cd /var/www/resourcespace && \
    svn co https://svn.resourcespace.com/svn/rs/releases/$RSVER . && \
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
##Cleanup
RUN apk del curl && \
    rm -rf /var/cache/apk/*

VOLUME ["/var/www/resourcespace/filestore"]
VOLUME ["/var/log/"]
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
