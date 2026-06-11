# Linux Networking Commands

Use these commands to validate addressing, routes, DNS, listening services, connectivity, and traffic paths.

| Command | Syntax | Explanation | Example | Expected Output |
|---|---|---|---|---|
| `ip addr` | `ip addr show [interface]` | Shows interfaces and IP addresses | `ip addr show eth0` | Private IP and interface state |
| `ip route` | `ip route show` | Shows kernel routing table | `ip route` | Default and local network routes |
| `ss` | `ss [options]` | Shows sockets and listening ports | `sudo ss -tulpn` | TCP/UDP listeners and processes |
| `ping` | `ping [-c count] <host>` | Tests ICMP reachability | `ping -c 4 10.0.2.10` | Replies or packet loss summary |
| `curl` | `curl [options] <URL>` | Tests HTTP/API connectivity | `curl -I https://aws.amazon.com` | HTTP response headers |
| `dig` | `dig <name>` | Queries DNS | `dig amazon.com` | DNS answer records |
| `nslookup` | `nslookup <name>` | Performs a simple DNS lookup | `nslookup amazon.com` | DNS server and resolved address |
| `traceroute` | `traceroute <host>` | Shows path hops | `traceroute 8.8.8.8` | Hop-by-hop route where permitted |
| `nc` | `nc -vz <host> <port>` | Tests a TCP port | `nc -vz 10.0.2.10 22` | Success or refusal/timeout |
| `tcpdump` | `tcpdump [options]` | Captures packet metadata | `sudo tcpdump -ni eth0 port 22` | Observed SSH packets |
| `hostname` | `hostname [-I]` | Shows host name or addresses | `hostname -I` | Assigned IP addresses |

## AWS Lab Validation

```bash
# On the bastion
ip addr show
ip route show
nc -vz <private-ip> 22

# On the private server
sudo ss -tulpn
```

Interpret timeouts carefully: a timeout can indicate a security group, network ACL, route, host firewall, or unreachable service. Test one layer at a time.
