#!/bin/bash

export GEM_HOME=/home/protected/gems

SITE_CHECKOUT=$HOME/site_checkout

GIT_DIR=$SITE_CHECKOUT/.git

PUBLIC_WWW=/home/public

echo 'Pulling latest changes and building site...'
cd $SITE_CHECKOUT

echo ''
git --git-dir=$GIT_DIR status

echo ''
git --git-dir=$GIT_DIR pull -f

echo ''
git --git-dir=$GIT_DIR status

echo ''
bundle install

echo ''
bundle exec jekyll build --destination $PUBLIC_WWW

echo ''
echo 'Done! Site built and deployed successfully.'

exit
