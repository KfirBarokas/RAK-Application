FROM python:3.11-slim

# Working directory
WORKDIR /opt/status-page

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv \
    gcc \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    libpq-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Create non-root user and ensure app directory is writable
RUN useradd --system --create-home --shell /bin/bash status-page \
 && mkdir -p /opt/status-page \
 && chown -R status-page:status-page /opt/status-page

# Copy app code and give ownership to non-root user
COPY --chown=status-page:status-page . .

# Make scripts executable
RUN chmod +x ./app-entrypoint.sh ./upgrade.sh

# Run as non-root
USER status-page

# Expose Gunicorn port
EXPOSE 8000

# Entrypoint script
CMD ["./app-entrypoint.sh"]
