/system script
add dont-require-permissions=no \
    name=update-iran-nonat \
    owner=admin \
    policy=read,write,policy,test \
    source=":local fileName \"iran-ip.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/list.rsc\"

/tool fetch url=\$url dst-path=\$fileName mode=https

/ip firewall address-list remove [find list=\"NoNAT\"]
/ipv6 firewall address-list remove [find list=\"IRv6\"]

/import file-name=\$fileName

/ipv6 firewall address-list remove [find list=\"IRv6\"]
/file remove \$fileName"

