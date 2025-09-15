FROM amazonlinux:latest

WORKDIR /opt/status-page

# Copy source code
COPY . .

# Install system dependencies (must come first)
RUN yum update -y && \
    yum install -y python3.11 python3.11-devel python3-pip gcc \
                   libxml2-devel libxslt-devel libffi-devel libpq-devel \
                   openssl-devel redhat-rpm-config shadow-utils && \
    yum clean all

# Create app user
RUN groupadd --system status-page && adduser --system -g status-page status-page

# Install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt

# Collect static files (STATIC_ROOT = /opt/status-page/statuspage/static)
ENV DJANGO_SETTINGS_MODULE=statuspage.settings
RUN python3 manage.py collectstatic --noinput

# Entrypoint
RUN chmod +x ./app-entrypoint.sh
CMD ["./app-entrypoint.sh"]

# TODO: eventually switch to `python:3.11-slim` instead of amazonlinux
