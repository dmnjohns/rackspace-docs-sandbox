#!/bin/sh

# VERSION=$(git describe --tag)
echo "enable git new"
source /opt/rh/rh-git29/enable
git branch -vv
git worktree list
git worktree add $WORKSPACE/dragons gh-pages
git worktree list
source $WORKSPACE/variables.sh
rm -rf dragons/*
cp -pr $buildstatic dragons/
#cp -R $buildfolder dragons/
cd dragons
git status
touch .nojekyll
ls # this line is just for debugging purposes
git add .
git status
git commit -m "Test, build, and publish with Jenkins (build # $BUILD_NUMBER)"
cd ../
rm -rf dragons/
git worktree list
git worktree prune -v
git branch -vv
git checkout gh-pages
git push origin gh-pages
