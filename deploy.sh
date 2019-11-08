#!/bin/bash

set -e
set -x
cd $(dirname $0)

orig=$(pwd)
# Loop for all workflow projects. You can change filter condition 
# as your actual project use.
if [ "${CIRCLE_BRANCH}" == "master" ]; then
    # deploy all files if branch == 'master'
    projects=$(find ./workflows -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*')
else
    # otherwise deploy only specific branches which has changed by the commit
    projects=$(git diff --name-only origin/master...HEAD | grep '^workflows' | sed -e 's;\(workflows/[^/]*\)/.*;\1;' | sort | uniq)
fi

for project in ${projects}; do
  cd ${project}

  digdag push $(basename $(pwd)) \
    -e api-workflow.treasuredata.com \
    -X client.http.headers.authorization="TD1 $TD_APIKEY" \
    -r $(date -u +"%Y-%m-%dT%H:%M:%SZ")-$(git rev-parse HEAD)

  cd $orig
done
