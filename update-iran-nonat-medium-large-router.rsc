/system script
add dont-require-permissions=no \
    name=update-iran-nonat-medium-large-router \
    owner=admin \
    policy=read,write,policy,test \
    source=":local fileName \"iran-ip.rsc\"
:local backupFile \"nonat-backup-before-update.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/list.rsc\"
:local ipv4List \"NoNAT\"
:local ipv6List \"IRv6\"
:local minFileSize 1000

:if ([:len [/file find name=\$backupFile]] > 0) do={
    /file remove \$backupFile
}

:do {
    /ip firewall address-list export file=\$backupFile where list=\$ipv4List
} on-error={
    :log warning \"Iran IP update: could not create backup file; stopping before update\"
    :return
}

:do {
    /tool fetch url=\$url dst-path=\$fileName mode=https
} on-error={
    :log warning \"Iran IP update: download failed; keeping old address list\"
    /file remove \$backupFile
    :return
}

:delay 3

:if ([:len [/file find name=\$fileName]] = 0) do={
    :log warning \"Iran IP update: downloaded file was not found; keeping old address list\"
    /file remove \$backupFile
    :return
}

:local fileSize [/file get \$fileName size]
:if (\$fileSize < \$minFileSize) do={
    :log warning \"Iran IP update: downloaded file is too small or empty; keeping old address list\"
    /file remove \$fileName
    /file remove \$backupFile
    :return
}

/ip firewall address-list remove [find list=\$ipv4List]
/ipv6 firewall address-list remove [find list=\$ipv6List]

:do {
    /import file-name=\$fileName
} on-error={
    :log warning \"Iran IP update: import failed; restoring old address list from backup file\"
    /ip firewall address-list remove [find list=\$ipv4List]
    /import file-name=\$backupFile
    /file remove \$fileName
    /file remove \$backupFile
    :return
}

/ipv6 firewall address-list remove [find list=\$ipv6List]

:if ([:len [/ip firewall address-list find list=\$ipv4List]] = 0) do={
    :log warning \"Iran IP update: new list has no NoNAT entries; restoring old address list from backup file\"
    /ip firewall address-list remove [find list=\$ipv4List]
    /import file-name=\$backupFile
    /file remove \$fileName
    /file remove \$backupFile
    :return
}

/file remove \$fileName
/file remove \$backupFile
:log info \"Iran IP update: NoNAT address list updated successfully\""
