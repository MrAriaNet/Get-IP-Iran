/system scheduler
add name=run-update-iran-ipv4-medium-large-router \
    start-time=04:00:00 \
    interval=1d \
    on-event="/system script run update-iran-ipv4-medium-large-router" \
    policy=read,write,policy,test
