FROM amazonlinux:latest AS django

WORKDIR /opt/status-page
COPY . .

RUN yum update -y && \
    yum install -y python3.11 python3.11-devel python3-pip gcc \
                   libxml2-devel libxslt-devel libffi-devel \
                   postgresql-devel zlib-devel bzip2 bzip2-devel \
                   xz-devel wget make \
                   openssl-devel redhat-rpm-config shadow-utils && \
    yum clean all

RUN pip3 install --upgrade pip setuptools wheel

# install requirements with verbose output for debugging
RUN pip3 install -r requirements.txt --verbose
ENV DJANGO_SETTINGS_MODULE=statuspage.settings
RUN python3 manage.py collectstatic --noinput

RUN groupadd --system status-page && adduser --system -g status-page status-page
RUN chmod +x ./app-entrypoint.sh

CMD ["./app-entrypoint.sh"]
