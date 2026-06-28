/system scheduler
add name=run-update-iran-nonat \
    start-time=04:00:00 \
    interval=1d \
    on-event="/system script run update-iran-nonat" \
    policy=read,write,policy,test
