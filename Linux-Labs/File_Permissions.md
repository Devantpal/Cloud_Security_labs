# Linux File Permissions

Linux permissions control which users can read, modify, or execute files. They are essential for protecting credentials, SSH keys, logs, and configuration.

## Permission Model

`r` means read, `w` means write, and `x` means execute. Permissions apply to the file owner, group, and others.

```text
-rwxr-x--- 1 ec2-user cloudops 1200 Jun 11 10:00 deploy.sh
 ||| ||| |||
 owner group others
```

| Command | Syntax | Explanation | Example | Expected Output |
|---|---|---|---|---|
| `ls -l` | `ls -l <path>` | Shows mode, owner, and group | `ls -l dev-key.pem` | Permission string and ownership |
| `chmod` | `chmod <mode> <path>` | Changes permissions | `chmod 400 dev-key.pem` | No output; key becomes owner-read-only |
| `chown` | `chown <owner>[:group] <path>` | Changes ownership | `sudo chown ec2-user:ec2-user app.log` | No output on success |
| `chgrp` | `chgrp <group> <path>` | Changes group | `sudo chgrp cloudops app.log` | No output on success |
| `umask` | `umask [mode]` | Controls default permissions | `umask 027` | New files exclude group write and all other access |
| `getfacl` | `getfacl <path>` | Shows ACL entries | `getfacl app.log` | Owner, group, and ACL details |
| `setfacl` | `setfacl -m <entry> <path>` | Adds/modifies an ACL | `setfacl -m u:analyst:r app.log` | No output on success |

## Numeric Modes

| Value | Permission |
|---|---|
| `4` | Read |
| `2` | Write |
| `1` | Execute |
| `7` | Read, write, execute |
| `6` | Read, write |
| `5` | Read, execute |

Examples:

```bash
chmod 400 dev-key.pem     # Owner can read; nobody else has access
chmod 640 application.log # Owner read/write, group read, others none
chmod 750 deploy.sh       # Owner full, group read/execute, others none
```

## Security Validation

```bash
find / -xdev -type f -perm /002 2>/dev/null
find /home -type f -name "*.pem" -exec ls -l {} \;
```

The first command identifies world-writable files on the current filesystem. The second reviews private-key permissions.
