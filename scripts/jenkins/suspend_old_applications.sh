#!/usr/bin/env bash
#
# Suspend old applications
# 
# Variables:
#
#   MARATHON_HOST (default: 10.0.1.11)
#   APPLICATION   (eg. shotgun)
#

header() {
  echo
  echo ====================================================================
  echo "$@"
  echo ====================================================================
  echo
}

header Getting a list of the running applications

curl http://${MARATHON_HOST}:8080/v2/apps 2> /dev/null | python -m json.tool | tee running_apps.json

header Deleting old instances

python get_old_application_ids.py "/$APPLICATION" < running_apps.json | \
  while read application ; do 
    echo "Deleting $application"
    curl -X DELETE http://${MARATHON_HOST}:8080/v2/apps/$application 2> /dev/null | python -m json.tool
  done

header Done
