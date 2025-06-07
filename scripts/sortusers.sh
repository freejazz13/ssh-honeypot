#!/bin/bash
# ordered passwd tries

# ssh-honeypot-top10-passwords.sh -- by Daniel Roberson
# -- Prints a list of the top 10 passwords found in the logs.
#
# -- usage: ssh-honeypot-top10-passwords.sh <logfile>

while getopts 1 arg ; do
  case $arg in
        1) LAST_ONLY=1 ;;
        *) echo "usage $0 -1 (last)" && exit 1 ;;
  esac
done
shift $((OPTIND - 1))

#grep -v -e "Error exchanging keys" $1 -e "] FATAL" -e "] ssh-honeypot " | awk {'print $8'} |sort |uniq -c |sort -rn |head -n 100
(
if [ -z $LAST_ONLY ] ; then
	cat /var/log/ssh-honeypot/ssh-honeypot.log  2>&-
	zcat /var/log/ssh-honeypot/ssh-honeypot.log*gz 2>&-
	bzcat /var/log/ssh-honeypot/ssh-honeypot.log*bz2 2>&-
else 
	cat /var/log/ssh-honeypot/ssh-honeypot.log  2>&-
fi 

) | grep -av HASSH | grep -aEv "^\s*$" | awk '{print $(NF-1)}' |sort |uniq -c |sort -rn | tee USERS | less -SFX
