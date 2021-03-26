#!/bin/bash

rm -rf /tmp/consc
mkdir /tmp/consc

echo "Repo, Master, Slave, Blacklist, Whitelist" > ~/dev/consc-lang/report.csv

REPOS=$(gh repo list quarkusio | awk -F ' ' ' { print $1 }')

for REPO in $REPOS; do
  
  REPO_NAME=$(echo $REPO | awk -F '/' ' { print $2 }')

  cd /tmp/consc
  git clone "git@github.com:$REPO"
  cd $REPO_NAME
  
  MASTER_COUNT=$(grep -rni 'master' . | wc -l)
  SLAVE_COUNT=$(grep -rni 'slave' . | wc -l)
  BLACKLIST_COUNT=$(grep -rni 'blacklist' . | wc -l)
  WHITELIST_COUNT=$(grep -rni 'whitelist' . | wc -l)


  echo "$REPO_NAME,$MASTER_COUNT,$SLAVE_COUNT,$BLACKLIST_COUNT,$WHITELIST_COUNT" >> ~/dev/consc-lang/report.csv
done
