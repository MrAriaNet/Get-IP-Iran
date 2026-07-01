# managed-by=mohavise-mikrotik-iran-ip
# project=get-ip-iran-evo
# do-not-edit-manually

:do {
    :local scriptName "update-iran-ipv6-small-router"
    :local scriptSource ":local fileName \"iran-ipv6.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/list-ipv6.rsc\"
:local ipv6List \"IRv6\"
:local backupList \"IRv6-backup-before-update\"
:local minFileSize 1000

:do {
    /tool fetch url=\$url dst-path=\$fileName mode=https
} on-error={
    :log warning \"Iran IPv6 update: download failed; keeping old address list\"
    :return
}

:delay 3

:if ([:len [/file find name=\$fileName]] = 0) do={
    :log warning \"Iran IPv6 update: downloaded file was not found; keeping old address list\"
    :return
}

:local fileSize [/file get \$fileName size]
:if (\$fileSize < \$minFileSize) do={
    :log warning \"Iran IPv6 update: downloaded file is too small or empty; keeping old address list\"
    /file remove \$fileName
    :return
}

/ipv6 firewall address-list remove [find list=\$backupList]
:foreach item in=[/ipv6 firewall address-list find list=\$ipv6List] do={
    :local address [/ipv6 firewall address-list get \$item address]
    :do {
        /ipv6 firewall address-list add list=\$backupList address=\$address
    } on-error={}
}

/ipv6 firewall address-list remove [find list=\$ipv6List]

:do {
    /import file-name=\$fileName
} on-error={
    :log warning \"Iran IPv6 update: import failed; restoring old address list\"
    /ipv6 firewall address-list remove [find list=\$ipv6List]
    :foreach item in=[/ipv6 firewall address-list find list=\$backupList] do={
        :local address [/ipv6 firewall address-list get \$item address]
        :do {
            /ipv6 firewall address-list add list=\$ipv6List address=\$address
        } on-error={}
    }
    /ipv6 firewall address-list remove [find list=\$backupList]
    /file remove \$fileName
    :return
}

:if ([:len [/ipv6 firewall address-list find list=\$ipv6List]] = 0) do={
    :log warning \"Iran IPv6 update: new list has no IRv6 entries; restoring old address list\"
    /ipv6 firewall address-list remove [find list=\$ipv6List]
    :foreach item in=[/ipv6 firewall address-list find list=\$backupList] do={
        :local address [/ipv6 firewall address-list get \$item address]
        :do {
            /ipv6 firewall address-list add list=\$ipv6List address=\$address
        } on-error={}
    }
    /ipv6 firewall address-list remove [find list=\$backupList]
    /file remove \$fileName
    :return
}

/ipv6 firewall address-list remove [find list=\$backupList]
/file remove \$fileName
:log info \"Iran IPv6 update: IRv6 address list updated successfully\""

    :if ([:len [/system script find name=$scriptName]] = 0) do={
        /system script add name=$scriptName dont-require-permissions=no policy=read,write,policy,test source=$scriptSource comment="managed-by=mohavise-mikrotik-iran-ip project=get-ip-iran-evo"
    } else={
        /system script set [/system script find name=$scriptName] dont-require-permissions=no policy=read,write,policy,test source=$scriptSource comment="managed-by=mohavise-mikrotik-iran-ip project=get-ip-iran-evo"
    }
}