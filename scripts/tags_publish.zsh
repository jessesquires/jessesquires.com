#!/bin/zsh

# pushes tags to NearlyFreeSpeech.net and pushes to GitHub mirror

echo "🏷 Pushing tags to origin..."
git push --tags origin

echo "🏷 Pushing tags to GitHub..."
git push --tags github

echo "🌈 Done!"
