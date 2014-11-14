#!/usr/bin/env bash
#
# Deploys the latest docker image for a given application into Marathon
#
# Variables:
#
#   MARATHON_HOST       (default: 10.0.1.11)
#   APPLICATION         (eg. shotgun)
#   INSTANCES           (the new number of instances)
#   DOCKER_IMAGE        (default: woorank/$APPLICATION)
#   CPUS		(the number of CPUs; default: 1)
#   MEMORY		(amount of memory in Mb; default 1024)
#   PORT		(the port to expose)
#

header() {
  echo
  echo ====================================================================
  echo "$@"
  echo ====================================================================
  echo
}

header Generating JSON for POST

rm -f *.json
tee application.json <<EOF
{
    "id": "${APPLICATION}-${BUILD_NUMBER}",
    "container": {
        "docker": {
            "image": "${DOCKER_IMAGE}"
        },
        "type": "DOCKER",
        "volumes": []
    },
    "args": [],
    "ports": [${PORT}],
    "cpus": ${CPUS},
    "mem": ${MEMORY},
    "instances": ${INSTANCES}
}
EOF

header Submit to Marathon at http://${MARATHON_HOST}:8080/

curl -X POST -H "Content-Type: application/json" http://${MARATHON_HOST}:8080/v2/apps -d@application.json 2>/dev/null | python -m json.tool

header Done
