# Git and GitHub Basics

## Initial Configuration

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
git config --global init.defaultBranch main
git config --list
```

## Daily Workflow

| Command | Purpose | Example | Expected Result |
|---|---|---|---|
| `git clone` | Copy a remote repository | `git clone git@github.com:owner/repo.git` | Local repository created |
| `git status` | Show changed/untracked files | `git status` | Working-tree summary |
| `git add` | Stage changes | `git add README.md` | File enters staging area |
| `git commit` | Record staged changes | `git commit -m "docs: add deployment guide"` | New local commit |
| `git push` | Upload commits | `git push origin main` | Remote branch updated |
| `git pull` | Fetch and integrate remote changes | `git pull --rebase origin main` | Local branch updated |
| `git log` | Show commit history | `git log --oneline --decorate -10` | Recent commit list |
| `git diff` | Show unstaged changes | `git diff` | Line-level differences |
| `git diff --staged` | Show staged changes | `git diff --staged` | Pending commit content |

## Branching Workflow

```bash
git switch -c docs/cloudtrail-lab
git status
git add AWS-Labs/Lab-09-CloudTrail/README.md
git commit -m "docs: document CloudTrail validation"
git push -u origin docs/cloudtrail-lab
```

Open a pull request, review the diff and automated checks, address feedback, merge through the approved strategy, then update local `main`.

```bash
git switch main
git pull --rebase origin main
```

## GitHub Workflow

1. Create an issue or define the change.
2. Create a focused branch.
3. Make small, reviewable commits.
4. Push the branch and open a pull request.
5. Run formatting, tests, security scans, and secret detection.
6. Review and merge after approval.

## Security Practices

- Never commit credentials, private keys, Terraform state, or sensitive plans.
- Use `.gitignore`, but remember it does not remove previously committed secrets.
- Enable branch protection, required reviews, and secret scanning.
- Sign commits where required.
- Review `git diff --staged` before every commit.
