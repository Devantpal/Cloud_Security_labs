# Linux Log Analysis

Log analysis helps detect authentication failures, service problems, privilege use, and suspicious activity.

## Common Locations

| Path | Typical Content |
|---|---|
| `/var/log/secure` | Authentication and sudo events on Amazon Linux/RHEL |
| `/var/log/auth.log` | Authentication events on Debian/Ubuntu |
| `/var/log/messages` | General system messages |
| `/var/log/syslog` | General system messages on Debian/Ubuntu |
| `/var/log/audit/audit.log` | Linux audit events when auditd is enabled |

## Commands

| Command | Syntax | Explanation | Example | Expected Output |
|---|---|---|---|---|
| `tail` | `tail -f <file>` | Follows new events | `sudo tail -f /var/log/secure` | Live authentication lines |
| `grep` | `grep [options] <pattern> <file>` | Filters matching events | `sudo grep -i "failed" /var/log/secure` | Failed login records |
| `awk` | `awk '<program>' <file>` | Extracts fields and aggregates | `awk '{print $1,$2,$3}' app.log` | Selected columns |
| `sort` | `sort [options]` | Sorts input | `sort events.txt` | Ordered lines |
| `uniq` | `uniq [-c]` | Counts adjacent duplicates | `sort ips.txt \| uniq -c` | Count per unique IP |
| `journalctl` | `journalctl [options]` | Queries systemd journal | `sudo journalctl -u sshd --since today` | Today's SSH service events |
| `last` | `last` | Shows login history | `last -n 10` | Recent sessions |
| `lastb` | `sudo lastb` | Shows failed login history | `sudo lastb -n 10` | Recent failed logins |

## Investigation Examples

```bash
# Recent SSH failures
sudo journalctl -u sshd --since "1 hour ago" | grep -i failed

# Most frequent source values in a space-delimited log field
awk '{print $NF}' /var/log/secure | sort | uniq -c | sort -nr | head

# Privileged commands
sudo grep -i sudo /var/log/secure | tail -n 20
```

## Analysis Workflow

1. Define the time window and affected host.
2. Preserve evidence and avoid altering source logs.
3. Filter relevant services, users, IPs, and event types.
4. Build a timeline and correlate with CloudTrail, CloudWatch, and VPC Flow Logs.
5. Record findings, containment actions, and follow-up improvements.
