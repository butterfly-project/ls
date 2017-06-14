#!/bin/bash

git release
git flush

TAG=`git tag | sort -V | tail -1`

notify-send Git "Релиз $TAG создан\n"
