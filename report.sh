#!/bin/bash

GH_ORG=$1
REPORT="$PWD/$2"

if [ "$2" == "" ]; then
  echo "Usgae: $0 <GH Org name> <Report output path>"
  exit -1
fi

rm -rf /tmp/consc
mkdir /tmp/consc

echo "Repo, Master, Slave, Blacklist, Whitelist" > $REPORT

REPOS=$(gh repo list $GH_ORG | awk -F ' ' ' { print $1 }')

for REPO in $REPOS; do
  
  REPO_NAME=$(echo $REPO | awk -F '/' ' { print $2 }')

  cd /tmp/consc
  git clone "git@github.com:$REPO"
  cd $REPO_NAME
  
  MASTER_COUNT=$(grep -rni 'master' . | wc -l)
  SLAVE_COUNT=$(grep -rni 'slave' . | wc -l)
  BLACKLIST_COUNT=$(grep -rni 'blacklist' . | wc -l)
  WHITELIST_COUNT=$(grep -rni 'whitelist' . | wc -l)


  echo "$REPO_NAME,$MASTER_COUNT,$SLAVE_COUNT,$BLACKLIST_COUNT,$WHITELIST_COUNT" >> $REPORT
done
