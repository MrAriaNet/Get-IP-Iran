#!/bin/sh

last=$(date)
url="https://stat.ripe.net/data/country-resource-list/data.json?resource=IR&v4_format=prefix"
filterv4='.data.resources.ipv4[]'
filterv6='.data.resources.ipv6[]'
output=$(curl --http2-prior-knowledge -s -X POST -H 'Connection: close' "$url")

rsc_fwv4()
{
	echo "#Last update: $last"
	echo "/ip firewall address-list remove [/ip firewall address-list find list=NoNAT]"
	echo "/ip firewall address-list"
}

rsc_fwv6()
{
	echo "#Last update: $last"
	echo "/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=IRv6]"
	echo "/ipv6 firewall address-list"
}

rsc_respinav4()
{
	echo ":do { add address=5.160.0.0/16 list=NoNAT} on-error={}"
	echo ":do { add address=46.209.0.0/16 list=NoNAT} on-error={}"
	echo ":do { add address=77.104.64.0/18 list=NoNAT} on-error={}"
}

rsc_intranetv4()
{
	echo ":do { add address=10.0.0.0/8 list=NoNAT} on-error={}"
}

rsc_address_add()
{
	for prefix in $1
	do
		echo ":do { add address=$prefix list=$2} on-error={}"
	done
}

rsc_v4()
{
	rsc_fwv4
	rsc_respinav4
	rsc_intranetv4
	rsc_address_add "$(echo "$output" | jq -r "$filterv4")" NoNAT
}

rsc_v6()
{
	rsc_fwv6
	rsc_address_add "$(echo "$output" | jq -r "$filterv6")" IRv6
}

case "$1" in
	v4)
		rsc_v4
		;;
	v6)
		rsc_v6
		;;
	split)
		rsc_v4 > list-ipv4.rsc
		rsc_v6 > list-ipv6.rsc
		;;
	*)
		rsc_v6
		rsc_v4
		;;
esac
