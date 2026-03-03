#Last update: Tue Mar  3 03:14:09 UTC 2026
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=IRv6]
/ipv6 firewall address-list
#Last update: Tue Mar  3 03:14:09 UTC 2026
/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]
/ip firewall address-list
:do { add address=5.160.0.0/16 list=NoNAT} on-error={}
:do { add address=46.209.0.0/16 list=NoNAT} on-error={}
:do { add address=77.104.64.0/18 list=NoNAT} on-error={}
:do { add address=10.0.0.0/8 list=NoNAT} on-error={}
