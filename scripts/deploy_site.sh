#!/bin/bash

export GEM_HOME=/home/protected/gems

SITE_CHECKOUT=$HOME/site_checkout

GIT_DIR=$SITE_CHECKOUT/.git

PUBLIC_WWW=/home/public

echo 'Pulling latest changes and building site...'
( set -x; cd $SITE_CHECKOUT )

echo ''
( set -x; git --git-dir=$GIT_DIR status )

echo ''
( set -x; git --git-dir=$GIT_DIR pull -f )

echo ''
( set -x; git --git-dir=$GIT_DIR status )

echo ''
( set -x; bundle install )

echo ''
( set -x; bundle exec jekyll build --destination $PUBLIC_WWW )

echo ''
echo 'Done! Site built and deployed successfully.'

exit
