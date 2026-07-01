# managed-by=mohavise-mikrotik-iran-ip
# project=get-ip-iran-evo
# do-not-edit-manually

:do {
    :local updateUrl "https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/update-iran-ipv6-medium-large-router.rsc"
    :local schedulerUrl "https://raw.githubusercontent.com/mohavise/Get-IP-Iran-evo/main/scheduler-update-iran-ipv6-medium-large-router.rsc"
    :local updateFile "update-iran-ipv6-medium-large-router.rsc"
    :local schedulerFile "scheduler-update-iran-ipv6-medium-large-router.rsc"

    /tool fetch url=$updateUrl dst-path=$updateFile mode=https
    /import file-name=$updateFile
    /file remove [find name=$updateFile]

    /tool fetch url=$schedulerUrl dst-path=$schedulerFile mode=https
    /import file-name=$schedulerFile
    /file remove [find name=$schedulerFile]

    /system script run update-iran-ipv6-medium-large-router
}