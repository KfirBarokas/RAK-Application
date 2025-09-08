FROM amazonlinux:latest

COPY . /opt/status-page

WORKDIR /opt/status-page

RUN yum update -y
RUN yum install -y python3.11 python3.11-devel python3-pip gcc libxml2-devel libxslt-devel libffi-devel libpq-devel openssl-devel redhat-rpm-config shadow-utils && yum clean all

RUN groupadd --system status-page && adduser --system -g status-page status-page


RUN chmod +x ./app-entrypoint.sh
cmd ["./app-entrypoint.sh"]

# TODO: change to python image!
