#!/bin/sh

set -e

chmod +x ./upgrade.sh

PYTHON=/usr/bin/python3.11 bash upgrade.sh

source venv/bin/activate

exec python3 statuspage/manage.py runserver 0.0.0.0:8000 --insecure
