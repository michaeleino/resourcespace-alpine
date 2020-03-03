# resourcespace
#### Resourcespace on linux alpine 3.10 


using Nginx Webserver,PHP-fpm, crond and supervisor to monitor the processes  
 mount `-v /var/log/rs-docker:/var/log`  
 need to create `nginx` and `php7` for each to be able to write logs.  
 `mkdir -p /var/log/rs-docker/{nginx,php7}`

 mount the conf filestore  
` -v /host/path/config.php:/var/www/resourcespace/include/config.php`  
to be able to set configuration from outside the container.  

the nginx listen internally on port:80
so to map port 8080 from host add  
`-p8080:80`

installed pkgs are:

        imagemagick
        ffmpeg
        ghostscript
        exiftool
        antiword
        xpdf
        perl-image-exiftool
        subversion
        mariadb-client
        php7-gd
        php7-dev
        php7-mysqli
        php7-mbstring
        php7-zip
        php7-xml
        php7-ldap
        php7-intl
        php7-curl
        php7-fpm
        nginx
        supervisor
