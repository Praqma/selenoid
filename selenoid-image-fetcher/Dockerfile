FROM alpine:3.9.5

RUN apk add --no-cache -q openrc jq docker

RUN rc-update add docker boot

RUN mkdir config && chmod -R 700 config

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 entrypoint.sh

ENTRYPOINT ["sh", "./entrypoint.sh"]



