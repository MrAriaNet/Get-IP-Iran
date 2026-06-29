/system script
add dont-require-permissions=no \
    name=update-iran-nonat \
    owner=admin \
    policy=read,write,policy,test \
    source=":local fileName \"iran-ip.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/list.rsc\"
:local ipv4List \"NoNAT\"
:local ipv6List \"IRv6\"
:local backupList \"NoNAT-backup-before-update\"
:local minFileSize 1000

:do {
    /tool fetch url=\$url dst-path=\$fileName mode=https
} on-error={
    :log warning \"Iran IP update: download failed; keeping old address lists\"
    :return
}

:delay 3

:if ([:len [/file find name=\$fileName]] = 0) do={
    :log warning \"Iran IP update: downloaded file was not found; keeping old address lists\"
    :return
}

:local fileSize [/file get \$fileName size]
:if (\$fileSize < \$minFileSize) do={
    :log warning \"Iran IP update: downloaded file is too small or empty; keeping old address lists\"
    /file remove \$fileName
    :return
}

:local fileContent [/file get \$fileName contents]
:if ([:find \$fileContent \"add address=\"] = nil) do={
    :log warning \"Iran IP update: downloaded file has no address entries; keeping old address lists\"
    /file remove \$fileName
    :return
}

/ip firewall address-list remove [find list=\$backupList]
:foreach item in=[/ip firewall address-list find list=\$ipv4List] do={
    :local address [/ip firewall address-list get \$item address]
    :do {
        /ip firewall address-list add list=\$backupList address=\$address
    } on-error={}
}

/ip firewall address-list remove [find list=\$ipv4List]
/ipv6 firewall address-list remove [find list=\$ipv6List]

:do {
    /import file-name=\$fileName
} on-error={
    :log warning \"Iran IP update: import failed after validation\"
    /ip firewall address-list remove [find list=\$ipv4List]
    :foreach item in=[/ip firewall address-list find list=\$backupList] do={
        :local address [/ip firewall address-list get \$item address]
        :do {
            /ip firewall address-list add list=\$ipv4List address=\$address
        } on-error={}
    }
    /ip firewall address-list remove [find list=\$backupList]
    /file remove \$fileName
    :return
}

/ipv6 firewall address-list remove [find list=\$ipv6List]

:if ([:len [/ip firewall address-list find list=\$ipv4List]] = 0) do={
    :log warning \"Iran IP update: imported file created no NoNAT entries; restoring old address list\"
    /ip firewall address-list remove [find list=\$ipv4List]
    :foreach item in=[/ip firewall address-list find list=\$backupList] do={
        :local address [/ip firewall address-list get \$item address]
        :do {
            /ip firewall address-list add list=\$ipv4List address=\$address
        } on-error={}
    }
    /ip firewall address-list remove [find list=\$backupList]
    /file remove \$fileName
    :return
}

/ip firewall address-list remove [find list=\$backupList]
/file remove \$fileName
:log info \"Iran IP update: NoNAT address list updated successfully\""
