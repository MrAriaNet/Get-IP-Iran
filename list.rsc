#Last update: Fri Aug  2 15:19:57 UTC 2024
/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]
/ip firewall address-list
:do { add address=10.0.0.0/8 list=NoNAT} on-error={}
