#!/bin/zsh

# pulls changes from github and deploys to NearlyFreeSpeech.net

echo '⬇️  Pulling changes from GitHub'
git pull github master

echo '⏩  git status'
git status

echo '🚀  Deploy to NFSN...'
make pub

exit
