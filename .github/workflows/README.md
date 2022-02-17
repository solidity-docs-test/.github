## Setting up the Bot 
- Create a new GitHub account and set up [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
- Go to repository Settings -> Security -> Secrets -> Actions -> Repository secrets
- create new secret: `PAT` with Personal Access Token of a bot
- in `create-pull-request.yaml` update bot related fields:
  - `jobs.createPullRequest.env.bot_username`
  - `jobs.createPullRequest.env.bot_email`


## Adding new translation repository

PR Bot requires related histories between original and translated repositories. To achieve common history, we can either:
- clone [ethereum/solidity](https://github.com/ethereum/solidity/)
- remove everything but `docs/` directory
- remove all branches but `develop`
- create a new repository in the [solidity-docs](https://github.com/solidity-docs) organization
- grant bot write access to that repository
- push from your clone to the newly created repository

Another option would be maintaining an up-to-date `en-english` repository as a template - with only the `docs` directory. That repository would be ready to fork and create a translation repository. In that case, the procedure would look like this:
- `git clone --bare git@github.com:solidity-docs/en-english.git`
- create a new GitHub repository, e.g. `solidity-docs/pl-polish`
- grant bot write access to that repository
- `cd en-english && git push git@github.com:solidity-docs-test/pl-polish.git`

In either case, pull request workflow file has to be updated:
- edit `.github/workflow/create-pull-request.yaml` 
- add language code to `jobs.createPullRequest.strategy.matrix.repos`

## How to transform translation repository to compatible form
- clone solidity repository `git@github.com:ethereum/solidity.git`
- rename solidity repository as translation repository, eg `id-indonesian`
- remove everything but `docs/` directory
- commit your changes
- clone old translation repository, e.g. `git clone git@github.com:solidity-docs/id-indonesian.git id-indonesian-old`
- if a translation repository has the wrong structure (root directory instead of `docs`), temporarily move all the files to the root directory and commit the change
- go to translation repository and add a remote - old translation: `git remote add indonesian-old ../id-indonesian-old/`
- fetch:   `git fetch indonesian-old`
- cherry pick commits using range: `git cherry-pick --strategy=recursive -X theirs e21d0103978a4b2aa689b402e1ab8df922280dc2..02d9d2730445071228959b1d6b970f87299e423b`
- move back everything to the `docs` directory and create a commit
- create new GitHub repository
- edit `.git/config` and change origin URL, eg:
```
  6 [remote "origin"]
  7         url = git@github.com:solidity-docs-test/id-indonesian.git
```
- create branch main: `git checkout -b main`
- push branch main: `git push origin main`
