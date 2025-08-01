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

* If your internet is disconnected and you cannot connect to GitHub to fetch the new list, you can use the script below so that the previous list is not deleted.

```bash
foreach i in={"NoNAT"} do={

  :local fileName $i
  :local url "https://raw.githubusercontent.com/MrAriaNet/Get-IP-Iran/main/list.rsc"

  /tool fetch url=$url dst-path=$fileName mode=http

  :delay 5

  :if ([/file find name=$fileName] != "") do={

    :if ([/file get $fileName size] > 0) do={

      /ip firewall address-list remove [/ip firewall address-list find list=$i]
      /import file-name=$fileName
      /file remove $fileName

    } else={
      :log warning "Download failed or empty file for $i — keeping old address list"
      /file remove $fileName
    }

  } else={
    :log warning "File not found after fetch — download likely failed — keeping old address list"
  }
}
```

## Author

[Aria](https://github.com/MrAriaNet)

## Special thanks from my best friends

[SS Salehi](https://github.com/salehi)

[Mahdi Habashi](https://t.me/mahdihabashi)
