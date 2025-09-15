FROM python:3.11-slim AS django

WORKDIR /opt/status-page

# Install system dependencies needed for building wheels
RUN apt-get update && apt-get install -y \
    gcc libpq-dev libxml2-dev libxslt1-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy app code
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Collect static files at build time
ENV DJANGO_SETTINGS_MODULE=statuspage.statuspage.configuration
RUN python manage.py collectstatic --noinput

# Entrypoint
RUN chmod +x ./app-entrypoint.sh
CMD ["./app-entrypoint.sh"]
