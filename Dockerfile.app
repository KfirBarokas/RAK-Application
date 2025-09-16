FROM python:3.11-alpine

WORKDIR /opt/status-page

RUN apk add --no-cache \
    build-base \
    gcc \
    musl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    openssl-dev \
    bash

RUN addgroup -S statuspage && adduser -S statuspage -G statuspage
RUN mkdir -p /opt/status-page && chown -R statuspage:statuspage /opt/status-page

COPY --chown=statuspage:statuspage . .

RUN chmod +x ./app-entrypoint.sh ./upgrade.sh

USER statuspage

EXPOSE 8000

# Entrypoint
CMD ["./app-entrypoint.sh"]
