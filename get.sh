#!/bin/sh

last=$(date);
url="https://stat.ripe.net/data/country-resource-list/data.json?resource=IR&v4_format=prefix"
filterv4='.data.resources.ipv4[]'
filterv6='.data.resources.ipv6[]'
output=$( curl --http2-prior-knowledge -s -X POST -H 'Connection: close' $url )

rsc_fwv4()
{
	echo "#Last update: $last";
	echo "/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]";
	echo "/ip firewall address-list";
}

rsc_fwv6()
{
	echo "#Last update: $last";
	echo "/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=IRv6]";
	echo "/ipv6 firewall address-list";
}

rsc_respinav4()
{
	echo ":do { add address=5.160.0.0/16 list=NoNAT} on-error={}";
	echo ":do { add address=46.209.0.0/16 list=NoNAT} on-error={}";
	echo ":do { add address=77.104.64.0/18 list=NoNAT} on-error={}";
}

rsc_intranetv4()
{
	echo ":do { add address=10.0.0.0/8 list=NoNAT} on-error={}";
}

# $1: ip list
# $2: address list name
# $3:
#   v4: IPv4 only
#   v6: IPv6 only
#   default: without section
rsc_address_add()
{
	if [ $3 = "v4" ]
	then
		rsc_fwv4
		rsc_respinav4
		rsc_intranetv4
	elif [ $3 = "v6" ]
	then
		rsc_fwv6
	fi
	for prefix in $1
	do
	    echo ":do { add address=$prefix list=$2} on-error={}";
	done;
}

# main
if [ "$1" != "v4" ]
then
	rsc_address_add "$( echo $output | jq -r $filterv6 )" IRv6 v6
fi

if [ "$1" != "v6" ]
then
	rsc_address_add "$( echo $output | jq -r $filterv4 )" NoNAT v4
fi
