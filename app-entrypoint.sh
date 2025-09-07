#!/bin/sh
# entrypoint.sh

# Run upgrade script (now DB is reachable)
set -e

chmod +x ./upgrade.sh
PYTHON=/usr/bin/python3.11 bash upgrade.sh

python3 statuspage/manage.py createsuperuser --noinput
exec python3 statuspage/manage.py runserver 0.0.0.0:8000 --insecure
