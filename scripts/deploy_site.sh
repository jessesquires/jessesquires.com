#!/bin/bash

# post-receive git hook
# should be copied to .git/hooks/post-receive in bare repo on server

export GEM_HOME=/home/private/.gem

SITE_CHECKOUT=$HOME/site_checkout

GIT_DIR=$SITE_CHECKOUT/.git

PUBLIC_WWW=/home/public

echo '🛠  Pulling latest changes and building site...'
cd $SITE_CHECKOUT

echo '⏩  git status'
git --git-dir=$GIT_DIR status

echo '⬇️  git pull'
git --git-dir=$GIT_DIR pull -f

echo '⏩  git status'
git --git-dir=$GIT_DIR status

echo '🛠  bundle install'
bundle install

echo '🛠  jekyll build'
bundle exec jekyll build --destination $PUBLIC_WWW

echo ' '
echo '🌈  Done! Site built and deployed successfully.'

exit
