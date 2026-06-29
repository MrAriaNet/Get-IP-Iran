/system script
add dont-require-permissions=no \
    name=update-iran-ipv4-small-router \
    owner=admin \
    policy=read,write,policy,test \
    source=":local fileName \"iran-ipv4.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/list-ipv4.rsc\"
:local ipv4List \"NoNAT\"
:local backupList \"NoNAT-backup-before-update\"
:local minFileSize 1000

:do {
    /tool fetch url=\$url dst-path=\$fileName mode=https
} on-error={
    :log warning \"Iran IPv4 update: download failed; keeping old address list\"
    :return
}

:delay 3

:if ([:len [/file find name=\$fileName]] = 0) do={
    :log warning \"Iran IPv4 update: downloaded file was not found; keeping old address list\"
    :return
}

:local fileSize [/file get \$fileName size]
:if (\$fileSize < \$minFileSize) do={
    :log warning \"Iran IPv4 update: downloaded file is too small or empty; keeping old address list\"
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

:do {
    /import file-name=\$fileName
} on-error={
    :log warning \"Iran IPv4 update: import failed; restoring old address list\"
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

:if ([:len [/ip firewall address-list find list=\$ipv4List]] = 0) do={
    :log warning \"Iran IPv4 update: new list has no NoNAT entries; restoring old address list\"
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
:log info \"Iran IPv4 update: NoNAT address list updated successfully\""
