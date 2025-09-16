FROM python:3.11-slim

WORKDIR /opt/status-page

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    libpq-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --system --create-home --shell /bin/bash status-page

COPY --chown=status-page:status-page . .

RUN chmod +x ./app-entrypoint.sh ./upgrade.sh

USER status-page

EXPOSE 8000

CMD ["./app-entrypoint.sh"]
