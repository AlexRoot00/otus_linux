#!/usr/bin/env bash
lockfile=/access-4560-644067.log

if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then
    trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
    while true
    do
        # What to do
        ls -ld ${lockfile}
        sleep 1
    done
   rm -f "$lockfile"
   trap - INT TERM EXIT
else
   echo "Failed to acquire lockfile: $lockfile."
   echo "Held by $(cat $lockfile)"
fi