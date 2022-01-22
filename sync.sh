originalUrl="https://github.com/ethereum/solidity.git"
#originalUrl="https://github.com/solidity-docs-test/en-english.git"

git remote add english $originalUrl # TODO: check of already exist

git config user.name "HAL9300"
git config user.email "piahoo+github.bot@gmail.com"

## Fetch from translated origin
git checkout
git fetch english --quiet

hash=$(git rev-parse  --short=10 english/develop)
syncBranch="sync-$hash"
echo $syncBranch

# pass the branch name to action "create PR"
echo ::set-output name=branchName::"$syncBranch"

## Check out a new branch 
git checkout -b $syncBranch # TODO: check of already exist

## pull from ethereum/solidity develop
git pull --rebase=false --squash english develop | tee pull.log
echo "pull done"

git rm -r --cached .
git add docs/* # TODO: in loop for every file/dir before the pull
git add README.md
git add .gitignore

conflicts=0
conflict_lines=()
while read line; do 
    if [[ "$line" =~ ^CONFLICT.* ]]; then
    ((conflicts+=1))
    conflict_lines+=$line
    fi
done < pull.log

echo $conflicts
echo $conflict_lines

git commit -am "merging all conflicts"

# If there are conflicts, create PR
git push --set-upstream origin $syncBranch
