# How to Create Your GitHub Repository

Do this **before** running the terminal command in `PUSH_COMMAND.txt`.

## Steps

1. Open https://github.com/new in your browser.
2. Make sure you're signed in as **khurang-r**.
3. Fill in the form:
   - **Repository name:** `RuckOps`
   - **Description:** *(optional)* `GPS workout tracker for rucking and running`
   - **Visibility:** **Private** (you can change this to public later if you want)
   - **Initialize this repository with:** leave **all three boxes unchecked** — do NOT add a README, .gitignore, or license. We're pushing those from your local copy.
4. Click **Create repository**.
5. GitHub will show a "Quick setup" page with several options. Ignore them — come back to this terminal and run the command in `PUSH_COMMAND.txt`.

## Verify the URL

After creation, the repo URL should be:

```
https://github.com/khurang-r/RuckOps
```

If it's something different (e.g. you typed the name in lowercase as `ruckops`), update the GitHub repo name to match exactly OR update `PUSH_COMMAND.txt` to match the URL you actually created. Git is case-sensitive on the URL.

## If you've already created the repo with files in it

If you accidentally checked "Add a README" and the repo isn't empty, the push will fail with a "non-fast-forward" error. Two options:

**Option A — easiest:** delete the GitHub repo (Settings → Danger Zone → Delete) and recreate it empty.

**Option B — keep the GitHub files:** run these instead of the standard push command:

```bash
cd ~/Downloads && unzip -o RuckOps-Project4.zip -d RuckOps-Project4 && cd RuckOps-Project4 && git init && git remote add origin https://github.com/khurang-r/RuckOps.git && git fetch && git checkout -b main origin/main && git add . && git commit -m "Project 4: Developer Brief + File Structure" && git push origin main
```

## Authentication notes

- If this is your first `git push` from this machine, GitHub will prompt for authentication.
- **Don't use your password** — GitHub disabled password auth in 2021.
- Use a **Personal Access Token (PAT)** instead: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token. Give it `repo` scope. Paste the token when prompted for a password.
- Or set up **GitHub CLI** (`gh auth login`) once and forget about tokens.
