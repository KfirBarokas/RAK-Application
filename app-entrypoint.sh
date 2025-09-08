#!/bin/sh

set -e

chmod +x ./upgrade.sh

PYTHON=/usr/bin/python3.11 bash upgrade.sh

source venv/bin/activate

cd /opt/status-page/statuspage 
exec gunicorn statuspage.wsgi:application --bind 0.0.0.0:8000 --workers 3
