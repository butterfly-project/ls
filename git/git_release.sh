#!/bin/bash

$(dirname "${BASH_SOURCE[0]}")/git_check_version.sh

git checkout master
git pull
git checkout dev
git pull

VERSION_MAJOR=`cat VERSION | cut -d'.' -f1`
VERSION_MINOR=`cat VERSION | cut -d'.' -f2`
VERSION_HOTFIX="0"

((VERSION_MINOR++))

NEW_VERSION="$VERSION_MAJOR.$VERSION_MINOR.$VERSION_HOTFIX"
FEATURE_BRANCH="release-$NEW_VERSION"

git checkout dev
git checkout -b $FEATURE_BRANCH

echo $NEW_VERSION > VERSION

git add VERSION
git commit -m "Release $NEW_VERSION"
