FROM amazonlinux:latest

RUN yum install -y httpd mod_ssl

COPY updated-files/ssl/ /etc/
RUN mkdir /etc/ssl/private

RUN mkdir -p /etc/httpd/sites-available
COPY updated-files/status-page.conf /etc/httpd/sites-available/

RUN systemctl enable --now httpd
RUN systemctl restart httpd
