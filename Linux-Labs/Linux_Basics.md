# Linux Basics for Cloud Operations

These commands support navigation, inspection, service management, and troubleshooting on cloud-hosted Linux systems.

| Command | Syntax | Explanation | Example | Expected Output |
|---|---|---|---|---|
| `pwd` | `pwd` | Prints the current directory | `pwd` | `/home/ec2-user` |
| `ls` | `ls [options] [path]` | Lists directory contents | `ls -la /var/log` | Detailed files including hidden entries |
| `cd` | `cd <directory>` | Changes the current directory | `cd /etc` | No output; prompt location changes |
| `mkdir` | `mkdir [-p] <directory>` | Creates directories | `mkdir -p labs/evidence` | No output on success |
| `touch` | `touch <file>` | Creates an empty file or updates timestamp | `touch validation.txt` | No output on success |
| `cp` | `cp [options] <source> <destination>` | Copies files or directories | `cp config.conf config.bak` | No output on success |
| `mv` | `mv <source> <destination>` | Moves or renames a path | `mv old.log archived.log` | No output on success |
| `rm` | `rm [options] <path>` | Removes files; use carefully | `rm validation.txt` | No output on success |
| `cat` | `cat <file>` | Displays file content | `cat /etc/os-release` | Operating-system metadata |
| `less` | `less <file>` | Opens scrollable file view | `less /var/log/messages` | Interactive file viewer |
| `head` | `head [-n N] <file>` | Shows first lines | `head -n 5 file.log` | First five lines |
| `tail` | `tail [-f] <file>` | Shows last lines or follows changes | `tail -f /var/log/secure` | New log lines as written |
| `grep` | `grep [options] <pattern> <file>` | Searches text | `grep -i failed /var/log/secure` | Matching authentication lines |
| `find` | `find <path> <expression>` | Finds files by criteria | `find /var/log -name "*.log"` | Matching paths |
| `whoami` | `whoami` | Prints effective username | `whoami` | `ec2-user` |
| `id` | `id [user]` | Shows UID, GID, and groups | `id` | User and group identifiers |
| `uname` | `uname -a` | Shows kernel/system details | `uname -a` | Kernel and architecture |
| `df` | `df -h` | Shows filesystem usage | `df -h` | Human-readable disk usage |
| `free` | `free -h` | Shows memory usage | `free -h` | RAM and swap totals |
| `ps` | `ps aux` | Lists processes | `ps aux` | Process table |
| `systemctl` | `systemctl <action> <service>` | Manages systemd services | `sudo systemctl status sshd` | Service state and recent logs |

## Useful Combinations

```bash
grep -i "failed" /var/log/secure | tail -n 20
find /etc -type f -perm /002 2>/dev/null
ps aux | grep sshd
```

## Safety Notes

Use `sudo` only when required, inspect commands before running them, and avoid destructive recursive operations unless the target has been verified.
