FROM python:3.11-alpine
WORKDIR /opt/status-page

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv \
    gcc \
    g++ \
    make \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    libc-dev \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --system --create-home --shell /bin/bash status-page \
 && mkdir -p /opt/status-page \
 && chown -R status-page:status-page /opt/status-page

COPY --chown=status-page:status-page . .

RUN chmod +x ./app-entrypoint.sh ./upgrade.sh

USER status-page
EXPOSE 8000
CMD ["./app-entrypoint.sh"]
