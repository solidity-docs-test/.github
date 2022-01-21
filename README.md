# .github
When creating a new translation:
- create a new repository
- grant Bot write access to newly created repository
- edit `.github/workflow/create-pull-request.yaml` 
- add language code to jobs.createPullRequest.strategy.matrix.repos
