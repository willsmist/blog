#!/bin/bash

cd ~/Workspace/blog

# push files to github
git add .
git commit -m "add new post"
git pull origin master
git push origin master
