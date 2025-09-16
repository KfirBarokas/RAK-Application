FROM python:3.11-alpine

# Set workdir
WORKDIR /opt/status-page

# Install system build dependencies for psycopg2, lxml, cryptography, etc.
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

# Create non-root user
RUN addgroup -S statuspage && adduser -S statuspage -G statuspage
RUN mkdir -p /opt/status-page && chown -R statuspage:statuspage /opt/status-page

# Copy project files
COPY --chown=statuspage:statuspage . .

# Ensure scripts are executable
RUN chmod +x ./app-entrypoint.sh ./upgrade.sh

# Switch to non-root
USER statuspage

# Expose port
EXPOSE 8000

# Entrypoint
CMD ["./app-entrypoint.sh"]
