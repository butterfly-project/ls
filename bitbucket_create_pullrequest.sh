#!/bin/bash

USER=$1
REPOSITORY=`git remote -v | grep push | grep origin | grep -Eo '\:.*\.' | sed 's/://g;s/\.//g'`;
BRANCH=`git rev-parse --abbrev-ref HEAD`

if [[ $BRANCH != feature-* ]]; then
    exit 0;
fi

TITLE="$BRANCH Auto Pull Request"

echo $TITLE

curl -i -X POST \
        --user "$USER" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -d '{
             "title": "$TITLE",
             "source": {
                 "branch": {
                     "name": "$BRANCH"
                 }
             },
             "destination": {
                 "branch": {
                     "name": "dev"
                 }
              },
             "close_source_branch": true
         }' \
        https://api.bitbucket.org/2.0/repositories/$REPOSITORY/pullrequests/
