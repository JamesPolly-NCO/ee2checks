#!/bin/bash
# Does the GEMPAK directory structure follow the standard: 
# $COMROOT/$NET/$model_ver/$RUN.$PDY/gempak?

if (($# != 1)); then
    echo "usage: $0 /path/to/com"
    echo "e.g. $0 /lfs/h1/ops/para/com/rrfs/v1.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi
rownum="013"

logfile=out${rownum}.log
[[ -e "${logfile}" ]] && rm -rf ${logfile}
echo "Checking COM directory structure..."
find $1 -type d -name "*gempak" | sort > ${logfile}
