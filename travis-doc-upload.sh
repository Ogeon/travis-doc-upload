#!/bin/sh

# License: CC0 1.0 Universal
# https://creativecommons.org/publicdomain/zero/1.0/legalcode

set -e

. ./scripts/travis-doc-upload.cfg

[ "$TRAVIS_BRANCH" = master ]

[ "$TRAVIS_PULL_REQUEST" = false ]

[ -e target/doc ]

eval key=\$encrypted_${SSH_KEY_TRAVIS_ID}_key
eval iv=\$encrypted_${SSH_KEY_TRAVIS_ID}_iv

mkdir -p ~/.ssh
openssl aes-256-cbc -K $key -iv $iv -in scripts/id_rsa.enc -out ~/.ssh/id_rsa -d
chmod 600 ~/.ssh/id_rsa

git clone --branch gh-pages git@github.com:$DOCS_REPO deploy_docs

cd deploy_docs
git config user.name "doc upload bot"
git config user.email "nobody@example.com"
mkdir -p $PROJECT_NAME
rm -rf $PROJECT_NAME/master
mv ../target/doc $PROJECT_NAME/master
git add -A $PROJECT_NAME
git commit -qm "doc upload for $PROJECT_NAME ($TRAVIS_REPO_SLUG)"
git push -q origin gh-pages
