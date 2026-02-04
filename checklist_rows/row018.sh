#!/bin/bash
# Are all used libraries approved for production 
# (/apps/ops/prod or /apps/prod)?

if (($# != 1)); then
    echo "usage: $0 /path/to/pkg"
    echo "e.g. $0 /lfs/h1/ops/para/package/rrfs.v1.0.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="018"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log


tmpout=${logdir}/out${rownum}.1
grep -Iir --exclude-dir=$1/fix 'module use ' $1/* > $tmpout
grep -v ':!' $tmpout \
    | grep -v ':*echo .*module use' \
    | grep -v ':.*#' > $logfile
