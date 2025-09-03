FROM amazonlinux:latest

COPY . /opt/status-page

WORKDIR /opt/status-page

RUN yum update -y
RUN yum install -y python3.11 python3.11-devel gcc libxml2-devel libxslt-devel libffi-devel libpq-devel openssl-devel redhat-rpm-config

RUN yum install -y httpd mod_ssl

COPY updated-files/ssl/ /etc/



RUN groupadd --system status-page && adduser --system -g status-page status-page


# postgres
RUN dnf install -y postgresql15 postgresql15-server
#RUN postgresql-setup --initdb
RUN /usr/pgsql-15/bin/initdb -D /var/lib/pgsql/data
#RUN systemctl enable --now postgresql
COPY updated-files/pg_hba.conf /var/lib/pgsql/data/


USER postgres
RUN psql -c "CREATE USER statuspage WITH PASSWORD 'abcdefgh123456';"
RUN psql -c "CREATE DATABASE statuspage OWNER statuspage;"
RUN psql -c "GRANT ALL PRIVILEGES ON DATABASE statuspage TO statuspage;"

USER root

# redis
RUN dnf install -y redis6
#RUN systemctl enable --now redis6
RUN redis6-server --daemonize yes
RUN redis-server --daemonize yes --bind 0.0.0.0


RUN chmod +x ./upgrade.sh
RUN PYTHON=/usr/bin/python3.11 bash upgrade.sh




RUN python3 statuspage/manage.py createsuperuser
# Django server running on port 8000
RUN python3 statuspage/manage.py runserver 0.0.0.0:8000 --insecure &
RUN python3 statuspage/manage.py collectstatic

RUN mkdir /etc/ssl/private

RUN mkdir -p /etc/httpd/sites-available
COPY updated-files/status-page.conf /etc/httpd/sites-available/

RUN systemctl enable --now httpd
RUN systemctl restart httpd

# GUNICORN
# TODO: put updated files into place
CMD ["gunicorn", "statuspage.wsgi:application", "--bind" , "127.0.0.1:8001", "&"]

