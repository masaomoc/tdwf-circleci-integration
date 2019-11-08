#!/bin/bash

set -e
cd $(dirname $0)

orig=$(pwd)
# Loop for all workflow projects. You can change filter condition 
# as your actual project use.
for project in $(find . -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*'); do
  cd ${project}

  digdag push $(basename $(pwd)) \
    -e api-workflow.treasuredata.com \
    -X client.http.headers.authorization="TD1 $TD_APIKEY" \
    -r $(date -u +"%Y-%m-%dT%H:%M:%SZ")-$(git rev-parse HEAD)

  cd ${orig}
done
