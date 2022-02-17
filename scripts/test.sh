#!/bin/bash
set -euo pipefail
LANGUAGE=$1

# extracts de from de-german
LANG_CODE=${LANGUAGE:0:2}
number_of_maintainers=1


assignee=$((($RANDOM%$number_of_maintainers)))
reviewer=$((($RANDOM%$number_of_maintainers)))

while [[ $assignee == "$reviewer" && number_of_maintainers -gt 1 ]]
do
    reviewer=$((($RANDOM%$number_of_maintainers)))
done

echo "reviewer=$(
    jq --raw-output ".maintainers[$reviewer]" "../langs/$LANG_CODE.json"
)" 

echo "assignee=$(
    jq --raw-output ".maintainers[$assignee]" "../langs/$LANG_CODE.json"
)" 
