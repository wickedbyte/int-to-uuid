# syntax=docker/dockerfile:1
##------------------------------------------------------------------------------
# PHP Build Stages
#
# No local files are COPYed, and are excluded via .dockerignore; all sources
# come from external stages or volume mounts.
##------------------------------------------------------------------------------

ARG PHP_VERSION=8.5-cli
FROM php:${PHP_VERSION} AS php
ARG WITH_XDEBUG=false
ARG USER_UID=1000
ARG USER_GID=1000
WORKDIR /app
SHELL ["/bin/bash", "-c"]
ENV PATH="/app/bin:/app/vendor/bin:/app/build/composer/bin:/home/dev/.composer/bin:$PATH"
ENV XDEBUG_MODE="off"

# Create a non-root user to run the application
RUN groupadd --gid $USER_GID dev \
    && useradd --uid $USER_UID --gid $USER_GID --groups www-data --create-home --shell /bin/bash dev

# Update the package list and install the latest version of the packages
RUN --mount=type=cache,target=/var/lib/apt,sharing=locked apt-get update && apt-get dist-upgrade --yes

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked apt-get install --yes --quiet --no-install-recommends \
    git \
    libzip-dev \
    unzip \
  && docker-php-ext-install zip \
  && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --from=ghcr.io/php/pie:bin /pie /usr/bin/pie

RUN if [ "${WITH_XDEBUG}" != "false" ]; then \
    pie install xdebug/xdebug; \
else \
    echo 'Skipping Installation of the Xdebug Extension...'; \
fi

RUN <<-'OUTER'
  set -eux
  mkdir -p "/home/dev/.composer";
  chown -R "dev:dev" "/home/dev/.composer";
  cat <<-'INNER' > /usr/local/etc/php/conf.d/settings.ini
      memory_limit=1G
      assert.exception=1
      error_reporting=E_ALL
      display_errors=1
      log_errors=on
      xdebug.log_level=0
      xdebug.mode=off
  INNER
OUTER

COPY --link --from=composer/composer /usr/bin/composer /usr/local/bin/composer
COPY --link --chown=$USER_UID:$USER_GID --from=composer/composer /tmp/* /home/dev/.composer/

USER dev

##------------------------------------------------------------------------------
# Utility Build Stages
##------------------------------------------------------------------------------

# Prettier Image for Code Formatting
FROM node:alpine AS prettier
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
WORKDIR /app
RUN npm install --global --save-dev --save-exact npm@latest prettier
ENTRYPOINT ["prettier"]
