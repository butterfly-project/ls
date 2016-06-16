#!/bin/bash

TASK_ID=$1

if [[ -z $TASK_ID ]]; then
    echo 'Set the task number'
    exit -1
fi

BRANCH="feature-$TASK_ID"

git checkout -b $BRANCH
