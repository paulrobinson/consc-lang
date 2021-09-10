#!/bin/bash

GH_ORG=$1
REPORT="$PWD/$2"
CODE_DATE="$3"
GREP_BASE_CMD="grep --exclude-dir='.git' -rni"

if [ "$2" == "" ]; then
  echo "Usage: $0 <GH Org name> <Report output path> [code date. Format: 2021-01-31]"
  exit -1
fi

rm -rf /tmp/consc
mkdir /tmp/consc

echo "Repo, Branch, Master, Slave, Blacklist, Whitelist" > $REPORT

REPOS=$(gh repo list $GH_ORG | awk -F ' ' ' { print $1 }')

for REPO in $REPOS; do
  
  REPO_NAME=$(echo $REPO | awk -F '/' ' { print $2 }')

  cd /tmp/consc
  git clone "git@github.com:$REPO"
  cd $REPO_NAME
 
  DEFAULT_BRANCH=$(git branch --show-current);

  if [ "$CODE_DATE" ]; then
    CUR_BRANCH=$(git branch --show-current)
    COMMIT_SHA=$(git rev-list -1 --before=$CODE_DATE $CUR_BRANCH)
    echo "Checking out code from $CODE_DATE on branch: $CUR_BRANCH with SHA: $COMMIT_SHA"
    git checkout $COMMIT_SHA
  fi

  rm -rf .git 
  MASTER_COUNT=$($GREP_BASE_CMD 'master' . | wc -l)
  SLAVE_COUNT=$($GREP_BASE_CMD 'slave' . | wc -l)
  BLACKLIST_COUNT=$($GREP_BASE_CMD 'blacklist' . | wc -l)
  WHITELIST_COUNT=$($GREP_BASE_CMD 'whitelist' . | wc -l)


  echo "$REPO_NAME,$DEFAULT_BRANCH,$MASTER_COUNT,$SLAVE_COUNT,$BLACKLIST_COUNT,$WHITELIST_COUNT" >> $REPORT
done
