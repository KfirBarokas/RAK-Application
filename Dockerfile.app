# Use a lightweight Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /opt/status-page

# Install system dependencies needed for your app
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    libpq-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd --system --create-home --shell /bin/bash status-page

# Copy app code with correct ownership
COPY --chown=status-page:status-page . .

# Ensure scripts are executable
RUN chmod +x ./app-entrypoint.sh ./upgrade.sh

# Switch to non-root user
USER status-page

# Expose Gunicorn port
EXPOSE 8000

# Run entrypoint
CMD ["./app-entrypoint.sh"]
