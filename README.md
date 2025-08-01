## Get IP Iran

This script is for get iran ip subnet and added to address list mikrotik

## How to use script

```bash
foreach i in={"NoNAT"} do={
  /tool fetch url="https://raw.githubusercontent.com/MrAriaNet/Get-IP-Iran/main/list.rsc" dst-path=NoNAT
  /ip firewall address-list remove [/ip firewall address-list find list=$i]
  /import file-name=$i
  /file remove $i
}
```

## Author

[Aria](https://github.com/MrAriaNet)

## Special thanks from my best friends

[SS Salehi](https://github.com/salehi)

[Mahdi Habashi](https://t.me/mahdihabashi)
