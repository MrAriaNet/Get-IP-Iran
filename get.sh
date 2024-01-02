#!/bin/bash
last=$(date)
echo "#Last Update: $last";
echo "/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]";
echo "/ip firewall address-list";

for range in $( curl --silent -X POST -H 'Connection: close' "https://stat.ripe.net/data/country-resource-list/data.json?resource=IR&v4_format=prefix" | jq .data.resources.ipv4[] | sed 's/"//g' ); do
    echo ":do { add address=$range list=NoNAT} on-error={}";
done;

echo ":do { add address=10.0.0.0/8 list=NoNAT} on-error={}";
