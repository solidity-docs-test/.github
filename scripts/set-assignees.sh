#!/bin/bash
set -euo pipefail
LANGUAGE=$1

# extracts de from de-german
LANG_CODE=${LANGUAGE:0:2}
number_of_maintainers=`jq '.maintainers | length' < ./.github-workflow/langs/$LANG_CODE.json`

assignee=$((($RANDOM%$number_of_maintainers)))
reviewer=$((($RANDOM%$number_of_maintainers)))

while [ "$assignee" -eq "$reviewer" ]
do
    reviewer=$((($RANDOM%$number_of_maintainers)))
done

echo "reviewer=$(
    jq .maintainers[$reviewer]                   \
    --raw-output                                 \
    < ./.github-workflow/langs/$LANG_CODE.json)" \
    >> $GITHUB_ENV

echo "assignee=$(
    jq .maintainers[$assignee]                   \
    --raw-output                                 \
    < ./.github-workflow/langs/$LANG_CODE.json)" \
    >> $GITHUB_ENV
