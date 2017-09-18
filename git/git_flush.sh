#!/bin/bash

$(dirname "${BASH_SOURCE[0]}")/git_check_version.sh

VERSION=`cat VERSION`
RELEASE_BRANCH=`git rev-parse --abbrev-ref HEAD`

git checkout dev
git pull
git merge --no-ff $RELEASE_BRANCH -m "Merge with $RELEASE_BRANCH"

git checkout master
git pull
git merge --no-ff $RELEASE_BRANCH -m "Merge with $RELEASE_BRANCH"

git branch -d $RELEASE_BRANCH
git tag -a $VERSION -m "Release $VERSION"

git push
git push --tags

git checkout dev
