#Last update: Thu Feb  5 21:47:46 UTC 2026
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=IRv6]
/ipv6 firewall address-list
#Last update: Thu Feb  5 21:47:46 UTC 2026
/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]
/ip firewall address-list
:do { add address=10.0.0.0/8 list=NoNAT} on-error={}
