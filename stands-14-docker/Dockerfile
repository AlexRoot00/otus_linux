FROM alpine:latest
RUN apk update
RUN apk upgrade -l
RUN apk add nginx
RUN apk add curl
RUN apk add lsof
RUN mkdir /var/www/html
CMD ["/bin/sh"]