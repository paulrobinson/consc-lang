#!/bin/bash

GH_ORG=$1
REPORT="$PWD/$2"
GREP_BASE_CMD="grep --exclude-dir='.git' -rni"

if [ "$2" == "" ]; then
  echo "Usgae: $0 <GH Org name> <Report output path>"
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

  rm -rf .git 
  MASTER_COUNT=$($GREP_BASE_CMD 'master' . | wc -l)
  SLAVE_COUNT=$($GREP_BASE_CMD 'slave' . | wc -l)
  BLACKLIST_COUNT=$($GREP_BASE_CMD 'blacklist' . | wc -l)
  WHITELIST_COUNT=$($GREP_BASE_CMD 'whitelist' . | wc -l)


  echo "$REPO_NAME,$DEFAULT_BRANCH,$MASTER_COUNT,$SLAVE_COUNT,$BLACKLIST_COUNT,$WHITELIST_COUNT" >> $REPORT
done
