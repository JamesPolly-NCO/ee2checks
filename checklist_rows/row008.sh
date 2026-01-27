#!/bin/bash
# Have all dependencies on non-operational servers been removed or 
# otherwise non-fatal?
if (($# != 1)); then
    echo "usage: $0 /path/to/package"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs.v1.0.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="008"

logfile=out${rownum}.log
[[ -e "${logfile}" ]] && rm -rf ${logfile}

echo "Not implemented. Need direction non-operational server to check?"
