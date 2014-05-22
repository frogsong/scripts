#!/bin/sh
# Downloads a configuration backup from a pfSense 1.2 server
# Corey Ford
# March 5, 2011

today=`date '+%Y%m%d'`
filename="$HOME/config-pfsense-$today.xml"
postdata="Submit=Download%20configuration"
server="pfsense"
proto="https"
url="$proto://$server/diag_backup.php"

curl -k -s -n -d "$postdata" -o "$filename" "$url"

