#!/bin/sh

set -e

chmod +x ./upgrade.sh
PYTHON=/usr/bin/python3.11 bash upgrade.sh

source venv/bin/activate

export DJANGO_SUPERUSER_USERNAME=kfir
export DJANGO_SUPERUSER_PASSWORD=roy
export DJANGO_SUPERUSER_EMAIL=kfir@example.com
python3 statuspage/manage.py createsuperuser --no-input 

exec python3 statuspage/manage.py runserver 0.0.0.0:8000 --insecure
