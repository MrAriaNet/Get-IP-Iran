# managed-by=mohavise-mikrotik-iran-ip
# project=get-ip-iran-evo
# do-not-edit-manually

:do {
    :local scheduleName "run-update-iran-ipv6-medium-large-router"
    :local scheduleEvent "/system script run update-iran-ipv6-medium-large-router"

    :if ([:len [/system scheduler find name=$scheduleName]] = 0) do={
        /system scheduler add name=$scheduleName start-time=04:10:00 interval=1d on-event=$scheduleEvent policy=read,write,policy,test comment="managed-by=mohavise-mikrotik-iran-ip project=get-ip-iran-evo"
    } else={
        /system scheduler set [/system scheduler find name=$scheduleName] start-time=04:10:00 interval=1d on-event=$scheduleEvent policy=read,write,policy,test comment="managed-by=mohavise-mikrotik-iran-ip project=get-ip-iran-evo"
    }
}