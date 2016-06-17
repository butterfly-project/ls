#!/bin/bash

git checkout dev
git pull
git remote prune origin
for f in `git branch | grep 'feature-' | sed -s 's/ //g'`; do echo "git branch -d $f"; done | bash
