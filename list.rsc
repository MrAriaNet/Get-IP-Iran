#Last update: Tue Mar 18 19:38:34 UTC 2025
/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]
/ip firewall address-list
:do { add address=10.0.0.0/8 list=NoNAT} on-error={}
