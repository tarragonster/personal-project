#Github

## Commandline
- cherry pick
```
git log -> get log of all commit, copy the desired commit [the commit]
git cherry-pick [the commit]
git push origin [target branch]
git log --oneline -> get all commit hash [the commit hash]
git reset [the commit hash] -> revert current branch back to previous state
```  

- rebase


- How do I undo 'git add' before commit?

```shell
git reset <file>
```
Ref: [How do I undo 'git add' before commit?](https://stackoverflow.com/questions/348170/how-do-i-undo-git-add-before-commit) \

- Can I specify multiple users for myself in .gitconfig?

Ref: [Can I specify multiple users for myself in .gitconfig?](https://stackoverflow.com/questions/4220416/can-i-specify-multiple-users-for-myself-in-gitconfig) \

- How to remove files from a folder in .gitignore?

```shell
git rm -r --cached Resources/
git commit -m "Delete Resources content, now ignored"
git push
```

Ref: [How to remove files from a folder in .gitignore?](https://stackoverflow.com/questions/71958273/how-to-remove-files-from-a-folder-in-gitignore)