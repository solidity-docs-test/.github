original = https://github.com/ethereum/solidity.git

# below step will be managed via github action
# git clone {{ translated }}
git remote add original $originalUrl

git config user.name Solidity-PR-Bot
git config user.email piahoo+github.bot@gmail.com

# Pull from translated origin
git checkout
git pull origin

git fetch original --quiet

hash=$(git rev-parse  --short=10 original/develop)
syncBranch="sync-$hash"
echo $syncBranch

# Check out a new branch
git checkout -b $syncBranch

# pull from ethereum/solidity develop
git pull --rebase=false --squash original develop | tee pull.log


if pull.log.contains("Already up to date."):
    exit

conflicts=0
conflict_lines=[]

for line in output:
    if line.starstWith("CONFLICT"):
        echo line
        conflicts+=1
        conflict_lines.append(line)



# If no conflicts, merge directly into main
if conflicts=0:
    echo "no conflicts found"
    git checkout {{ default-branch }}
    git merge $syncBranch
    git push origin {{ default-branch }}
    exit

# If there are conflicts, create PR
git push --set-upstream origin $syncBranch
PR_title="Sync with {{ ethereum/solidity }} @ $hash"
PR_conflictsText = "The following files have conflicts and may need new translations:"
for conflict_file in conflict_lines:
    PR_conflictsText.append(" * [ ] [$conflict_file}](/ethereum/solidity/commits/main/$conflict_file)")

PR_body="This PR was automatically generated.
    Merge changes from [ethereum/solidity](https://github.com/ethereum/solidity/commits/develop) at $shortHash"

if conflicts=0:
    PR_body.append("No conflicts were found.")
else:
    PR_body.append($PR_conflictsText)

GitHub Action: Create PR

