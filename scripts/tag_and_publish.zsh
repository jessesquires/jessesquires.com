#!/bin/zsh

# creates a git tag and pushes to NearlyFreeSpeech.net and GitHub mirror

if [ -z "$1" ]
then
    echo "Error: please provide a tag"
    exit
fi

echo "Creating tag $1"
git tag -a "$1" -m "$1"

echo "🏷  Pushing tags to origin..."
git push --tags origin

echo "🏷  Pushing tags to GitHub..."
git push --tags github

echo "🌈  Done!"
