#Last update: Thu Feb 27 09:23:13 UTC 2025
/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]
/ip firewall address-list
:do { add address=10.0.0.0/8 list=NoNAT} on-error={}
