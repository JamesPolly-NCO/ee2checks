#!/bin/bash
# Have references to NWGES been removed from the directory structure?

if (($# != 1)); then
    echo "usage: $0 /path/to/com"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs.v1.0.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi
rownum="014"

logfile=out${rownum}.log
[[ -e "${logfile}" ]] && rm -rf ${logfile}
echo "Checking for NWGES..."
grep -Iir 'nwges' $1/* > ${logfile}
