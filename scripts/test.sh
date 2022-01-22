#!/bin/bash
set -euo pipefail

#echo "pr_title=Sync with ethereum/solidity@develop $(date +%d-%m-%Y)" >> $GITHUB_ENV

#PR_body=$(cat << EOF
#This PR was automatically generated. 
#
#Merge changes from [solidity](https://github.com/ethereum/solidity)@develop 
#The following files have conflicts and may need new translations: 
#EOF
#)
#
#echo "pr_body<<EOF"                                                   > $GITHUB_ENV
#echo "$PR_body"                                                       >> $GITHUB_ENV
git status --short         | \
    grep "docs"            | \
    awk '{print "- [ ] \
    ["$2"](https://github.com/ethereum/solidity/tree/develop/"$2")"}' >> $GITHUB_ENV
#echo ""                                                               >> $GITHUB_ENV
#echo "Please fix the conflicts by pushing new commits \
#to this pull request, either by editing the files     \
#directly on GitHub or by checking out this branch."                   >> $GITHUB_ENV
#echo ""                                                               >> $GITHUB_ENV
#echo "## DO NOT SQUASH MERGE THIS PULL REQUEST!"                      >> $GITHUB_ENV
#echo -n 'Doing so will "erase" the commits from main '                >> $GITHUB_ENV
#echo "and cause them to show up as conflicts the next \
#time we merge."                                                       >> $GITHUB_ENV
#echo "EOF"                                                            >> $GITHUB_ENV


printf "%s\n" {\
"pr_body<<EOF",\
"This PR was automatically generated.",\
\ ,\
git status --short         | \
    grep "docs"            | \
    awk '{print "- [ ] \
    ["$2"](https://github.com/ethereum/solidity/tree/develop/"$2")"}',
"Merge changes from [solidity](https://github.com/ethereum/solidity)@develop",\
"The following files have conflicts and may need new translations: ",\
\ ,\
"Please fix the conflicts by pushing new commits \
to this pull request, either by editing the files \
directly on GitHub or by checking out this branch.",\
\ ,\
"## DO NOT SQUASH MERGE THIS PULL REQUEST!",\
"Doing so will erase the commits from main and cause them to show up as \
conflicts the next time we merge.",\
"EOF",\
} > test
