# What to Do If a Credential Is Leaked in a Public Git Repo (Beginner Runbook)

If you accidentally push a secret (password, API key, `.pem` key, AWS keys, connection strings) to a public repo, treat it as **compromised immediately**.

---

## 1) Confirm what leaked
Examples of leaked credentials:
- `.pem` or `.ppk` key files
- AWS Access Key + Secret Key
- GitHub tokens (PAT)
- Database connection strings (MongoDB URI)
- `.env` files (often contain secrets)

If you are unsure what leaked, assume **it did leak** and rotate it.

---

## 2) Contain it (stop the damage fast)
### A) Remove public access ASAP
- If possible, make the repo **private immediately** (temporary).
- Or delete the repo temporarily if that’s allowed.

### B) Revoke / rotate the credential immediately (MOST IMPORTANT)
Do not wait.

Examples:
- **GitHub token leaked** → delete token + create a new one
- **AWS keys leaked** → disable/delete key + create new key
- **MongoDB password leaked** → change password + update app config
- **SSH key leaked (`.pem`)** → replace key and remove old key access

---

## 3) Fix the repo (remove the secret from the codebase)
### A) Delete the secret file from the repo
If it’s a file (example: `tech517.pem`, `.env`):

```bash
git rm --cached tech517.pem
git rm --cached .env
```

## Rule of Thumb
	•	File → no -r
	•	Folder → use -r