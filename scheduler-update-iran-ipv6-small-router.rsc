/system scheduler
add name=run-update-iran-ipv6-small-router \
    start-time=04:10:00 \
    interval=1d \
    on-event="/system script run update-iran-ipv6-small-router" \
    policy=read,write,policy,test
