#!/bin/sh

setup_git() {
  git config --global user.email "tran.xuan.nam@framgia.com"
  git config --global user.name "Tran Xuan Nam"
}

commit_files() {
  cd _site
  git init
  git remote add origin-pages https://${GH_TOKEN}@github.com/namtx/namtx.github.io.git > /dev/null 2>&1
  git add -A
  git commit --allow-empty -m "Travis build: $TRAVIS_BUILD_NUMBER"
  git push --quiet --set-upstream origin-pages master -f
}

setup_git
commit_files
