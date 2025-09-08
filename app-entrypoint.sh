#!/bin/sh
# entrypoint.sh

# Run upgrade script (now DB is reachable)
set -e

chmod +x ./upgrade.sh
PYTHON=/usr/bin/python3.11 bash upgrade.sh

source venv/bin/activate
#python3 statuspage/manage.py migrate
#python3 statuspage/manage.py collectstatic --no-input
python3 statuspage/manage.py createsuperuser

exec python3 statuspage/manage.py runserver 0.0.0.0:8000 --insecure
