/system scheduler
add name=run-update-iran-nonat-medium-large-router \
    start-time=04:00:00 \
    interval=1d \
    on-event="/system script run update-iran-nonat-medium-large-router" \
    policy=read,write,policy,test
