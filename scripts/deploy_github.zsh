#!/bin/zsh

# pulls changes from github and deploys to NearlyFreeSpeech.net

set -e

echo '⬇️  Pulling changes from GitHub'
git pull github master

echo '⏩  install and build'
make install
make build

echo '⏩  git status'
git status

echo '🚀  Deploy to NFSN...'
make pub

exit
