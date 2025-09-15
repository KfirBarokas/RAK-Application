FROM python:3.11-slim AS django

WORKDIR /opt/status-page
COPY . .

RUN apt-get update && apt-get install -y \
    gcc libpq-dev libxml2-dev libxslt1-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Fake env vars so collectstatic doesn't crash
ENV DJANGO_SETTINGS_MODULE=statuspage.statuspage.configuration \
    DB_NAME=fake \
    DB_USER=fake \
    DB_PASS=fake \
    DB_HOST=localhost \
    DB_PORT=5432 \
    REDIS_HOST=localhost \
    REDIS_PORT=6379

# Collect static files into STATIC_ROOT
RUN python manage.py collectstatic --noinput --verbosity 2

RUN chmod +x ./app-entrypoint.sh
CMD ["./app-entrypoint.sh"]
