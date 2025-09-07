FROM amazonlinux:latest

COPY . /opt/status-page

WORKDIR /opt/status-page

RUN yum update -y
RUN yum install -y python3.11 python3.11-devel gcc libxml2-devel libxslt-devel libffi-devel libpq-devel openssl-devel redhat-rpm-config shadow-utils

RUN groupadd --system status-page && adduser --system -g status-page status-page


#RUN chmod +x ./upgrade.sh
#RUN PYTHON=/usr/bin/python3.11 bash upgrade.sh
RUN chmod +x ./app-entrypoint.sh
cmd ["./app-entrypoint.sh"]


#RUN python3 statuspage/manage.py createsuperuser
# Django server running on port 8000
#RUN python3 statuspage/manage.py collectstatic # is needed?
#RUN python3 statuspage/manage.py runserver 0.0.0.0:8000 --insecure &

# stop currently running application!@!!!
