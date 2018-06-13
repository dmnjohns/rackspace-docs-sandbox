#!/bin/sh

set -e
source /opt/rh/rh-git29/enable
source /opt/rh/python27/enable
virtualenv jenkinspy2
source jenkinspy2/bin/activate
python -V
pip install --upgrade pip
pip install -r requirements.txt
make htmlvers
git branch -vv
