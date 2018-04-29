#!/bin/bash

notify-send Git "push\n"

git stash
git pull
git stash apply
git add .
git commit -m "Auto commit"
git push

notify-send Git "push send\n"
