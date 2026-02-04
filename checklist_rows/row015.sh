#!/bin/bash
# Is the prod_util module loaded and used?

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
rownum="015"

logfile=out${rownum}.log
[[ -e "${logfile}" ]] && rm -rf ${logfile}
echo "Checking for redundant prod_util..."
grep -r 'prod_util' $1/ecf/* > ${logfile}
