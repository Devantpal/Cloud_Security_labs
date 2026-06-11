# GitHub SSH Key Setup

SSH keys provide authenticated Git access without sending a password on every operation.

## Generate a Key

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

Expected prompts ask for the save location and a passphrase. Use a strong passphrase and keep the private key secret.

## Start the Agent and Add the Key

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Expected output includes an agent process ID and confirmation that the identity was added.

## Add the Public Key to GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy only the `.pub` value into GitHub **Settings > SSH and GPG keys > New SSH key**. Never upload or share `id_ed25519`.

## Test Authentication

```bash
ssh -T git@github.com
```

Expected output confirms successful authentication while noting that GitHub does not provide shell access.

## Clone with SSH

```bash
git clone git@github.com:<owner>/<repository>.git
```

## Security Checklist

- Protect the private key with a passphrase and restrictive permissions.
- Use separate keys for different trust contexts.
- Remove old or unknown keys from GitHub.
- Never reuse an EC2 `.pem` key as a GitHub key.
- Review organization SSO and signing requirements.
