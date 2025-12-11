# syntax=docker/dockerfile:1
ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-cli
WORKDIR /app
ENV PATH "/app/bin:/app/vendor/bin:/app/build/composer/vendor/bin:$PATH"
ENV COMPOSER_HOME "/app/build/composer"
ARG USER_UID=1000
ARG USER_GID=1000

RUN <<-EOF
  groupadd --gid ${USER_GID} dev;
  useradd --system --create-home --uid ${USER_UID} --gid ${USER_GID} --shell /bin/bash dev;
  apt-get update;
  apt-get install -y --no-install-recommends \
    curl \
    git \
    less \
    libgmp-dev \
    libzip-dev \
    unzip \
    vim-tiny \
    zip \
    zlib1g-dev;
  apt-get clean;
EOF

COPY --link --from=ghcr.io/php/pie:bin /pie /usr/bin/pie
COPY --link --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --link --from=composer /tmp/* /home/dev/.composer/

RUN docker-php-ext-install zip
RUN pie install xdebug/xdebug

RUN <<EOF > /usr/local/etc/php/conf.d/settings.ini
memory_limit=1G
assert.exception=1
error_reporting=E_ALL
display_errors=1
log_errors=on
xdebug.log_level=0
xdebug.mode=debug
xdebug.client_host=host.docker.internal
xdebug.start_with_request=trigger
xdebug.idekey=PHPSTORM
xdebug.output_dir=/app/build/xdebug
EOF

USER dev
