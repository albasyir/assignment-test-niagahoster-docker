FROM nginx:stable-alpine

# we work on :
WORKDIR /var/www/htdocs


# Update latest OS that we have :)
RUN apk update && apk upgrade

# we need nginx configuration
COPY docker-nginx.conf /etc/nginx/nginx.conf

# Install the software which we need ~ PHP :)
RUN apk add --no-cache php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl

# Make sure "service overcome" with our project :) for each boot up!
# RUN rc-update add php-fpm7 default BUG

# we should copy our base project to right plase right.
COPY . .
RUN rm ./docker-nginx.conf


# export nginx configuraton port
EXPOSE 8000