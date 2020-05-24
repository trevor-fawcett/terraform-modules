# CodeCommit Module

This is a nice simple one to try, but scarily easy to destroy your repository if included with other infrastructure!

## Post-creation Steps

CodeCommit repositories are created without the default branch, so the first step is to initialise the repository's default branch with something like the following (assuming repository is called `repo-name` and the default branch is `master`).

```bash
git clone https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/repo-name
cd repo-name
echo '# Repository Name' > readme.md
git commit -a -m 'initial commit'
git push -u origin master
```