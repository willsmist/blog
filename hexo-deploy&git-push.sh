#!/bin/bash

cd ~/Workspaces/blog

# push files to github
git add .
git commit -m "add new post"
git pull origin master
git push origin master

# deploy site
hexo cl && hexo g && hexo d && hexo cl
