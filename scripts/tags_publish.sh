#!/bin/bash

echo "Pushing tags to origin..."
git push --tags origin

echo "Pushing tags to GitHub..."
git push --tags github

echo ""
