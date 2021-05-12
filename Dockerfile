# https://wiki.alpinelinux.org/wiki/Nginx_with_PHP
FROM alpine:3.13

# PHP Depedencies
RUN apk --no-cache add \ 
  php8 php8-fpm php8-opcache php8-mysqli php8-pdo_mysql \ 
  php8-json php8-openssl curl php8-curl php8-zlib php8-gettext \
  php8-xml php8-phar php8-intl php8-dom php8-xmlreader \
  php8-ctype php8-session php8-mbstring php8-gd

RUN apk --no-cache add nano mysql-client

COPY ./docker/fpm.conf /etc/php8/php-fpm.d/www.conf
COPY ./docker/php.ini /etc/php8/conf.d/custom.ini

RUN apk add --no-cache nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache supervisor
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN chown -R nobody.nobody /var/www/html
RUN chown -R nobody.nobody /run
RUN chown -R nobody.nobody /var/lib/nginx
RUN chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

COPY --chown=nobody . /var/www/html

EXPOSE 8004
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

