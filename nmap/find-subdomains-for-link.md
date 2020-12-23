# Find subdomains for a specific link

See for more information here, https://nmap.org/nsedoc/scripts/dns-brute.html


```
(16:46:49) stavros@stavros-VirtualBox:~ $ nmap --script dns-brute www.gov.gr
Starting Nmap 7.80 ( https://nmap.org ) at 2020-12-21 16:47 EET
Nmap scan report for www.gov.gr (212.205.126.18)
Host is up (0.039s latency).
Other addresses for www.gov.gr (not scanned): 2a02:587:8ff:25::d4cd:4d98 2a02:587:8ff:25::d4cd:4dab 212.205.126.16
Not shown: 997 filtered ports
PORT    STATE  SERVICE
53/tcp  closed domain
80/tcp  open   http
443/tcp open   https

Host script results:
| dns-brute: 
|   DNS Brute-force hostnames: 
|     testing.gov.gr - 52.85.156.105
|     testing.gov.gr - 52.85.156.120
|     testing.gov.gr - 52.85.156.81
|     testing.gov.gr - 52.85.156.88
|     apps.gov.gr - 84.205.254.134
|     www.gov.gr - 212.205.126.16
|     www.gov.gr - 212.205.126.18
|     www.gov.gr - 2a02:587:8ff:25::d4cd:4d98
|     www.gov.gr - 2a02:587:8ff:25::d4cd:4dab
|_    demo.gov.gr - 195.251.26.202

Nmap done: 1 IP address (1 host up) scanned in 69.96 seconds

```

