/system script
add dont-require-permissions=no \
    name=update-iran-ipv6-medium-large-router \
    owner=admin \
    policy=read,write,policy,test \
    source=":local fileName \"iran-ipv6.rsc\"
:local backupFile \"irv6-backup-before-update.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/list-ipv6.rsc\"
:local ipv6List \"IRv6\"
:local minFileSize 1000

:if ([:len [/file find name=\$backupFile]] > 0) do={
    /file remove \$backupFile
}

:do {
    /ipv6 firewall address-list export file=\$backupFile where list=\$ipv6List
} on-error={
    :log warning \"Iran IPv6 update: could not create backup file; stopping before update\"
    :return
}

:do {
    /tool fetch url=\$url dst-path=\$fileName mode=https
} on-error={
    :log warning \"Iran IPv6 update: download failed; keeping old address list\"
    /file remove \$backupFile
    :return
}

:delay 3

:if ([:len [/file find name=\$fileName]] = 0) do={
    :log warning \"Iran IPv6 update: downloaded file was not found; keeping old address list\"
    /file remove \$backupFile
    :return
}

:local fileSize [/file get \$fileName size]
:if (\$fileSize < \$minFileSize) do={
    :log warning \"Iran IPv6 update: downloaded file is too small or empty; keeping old address list\"
    /file remove \$fileName
    /file remove \$backupFile
    :return
}

/ipv6 firewall address-list remove [find list=\$ipv6List]

:do {
    /import file-name=\$fileName
} on-error={
    :log warning \"Iran IPv6 update: import failed; restoring old address list from backup file\"
    /ipv6 firewall address-list remove [find list=\$ipv6List]
    /import file-name=\$backupFile
    /file remove \$fileName
    /file remove \$backupFile
    :return
}

:if ([:len [/ipv6 firewall address-list find list=\$ipv6List]] = 0) do={
    :log warning \"Iran IPv6 update: new list has no IRv6 entries; restoring old address list from backup file\"
    /ipv6 firewall address-list remove [find list=\$ipv6List]
    /import file-name=\$backupFile
    /file remove \$fileName
    /file remove \$backupFile
    :return
}

/file remove \$fileName
/file remove \$backupFile
:log info \"Iran IPv6 update: IRv6 address list updated successfully\""
