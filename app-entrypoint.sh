#!/bin/sh
set -e

chmod +x ./upgrade.sh

# Detect Python 3.11 automatically
PYTHON=$(command -v python3.11) bash upgrade.sh

. venv/bin/activate

cd /opt/status-page/statuspage
exec gunicorn statuspage.wsgi:application --bind 0.0.0.0:8000 --workers 3
