FROM elixir:1.8-alpine

RUN apk add --no-cache build-base git

RUN mkdir -p /var/www/tp-iasc
WORKDIR /var/www/tp-iasc

## Install dependencies

COPY mix* /var/www/tp-iasc/
RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force
RUN mix deps.compile

## Copy main files and precompile

COPY config/ /var/www/tp-iasc/config/
COPY lib /var/www/tp-iasc/lib/

## Copy database and shell scripts

COPY bin/ /var/www/tp-iasc/bin/

ENTRYPOINT ["/var/www/tp-iasc/bin/main.sh", "main"]
