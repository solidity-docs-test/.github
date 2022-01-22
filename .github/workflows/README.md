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
