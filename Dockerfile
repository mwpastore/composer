FROM alpine:edge

LABEL   org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.docker.dockerfile="/Dockerfile" \
        org.label-schema.vcs-url="https://github.com/soifou/composer"

RUN apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    wget \
    ca-certificates \
    git \
    openssh \
    php5 \
    php5-curl \
    php5-ctype \
    php5-dom \
    php5-iconv \
    php5-json \
    php5-openssl \
    php5-pdo \
    php5-pdo_mysql \
    php5-phar \
    php5-posix \
    php5-zlib

COPY composer-installer /usr/local/bin/composer-installer
RUN cd /usr/local/bin && \
    chmod +x composer-installer && \
    sh composer-installer && \
    mv composer.phar composer && \
    rm composer-installer

COPY php.ini /etc/php5/conf.d/50-setting.ini

COPY composer-wrapper /usr/local/bin/composer-wrapper
RUN chmod +x /usr/local/bin/composer-wrapper

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/composer/.composer

WORKDIR /usr/src/app
VOLUME ["/home/composer/.composer"]
ENTRYPOINT ["/usr/local/bin/composer-wrapper"]