#!/bin/bash
# Are scripts written in bash, ksh, perl or python?

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
rownum="021"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log


findout=${logdir}/out${rownum}.find
echo "Checking file types ..."
find $1/ush -name "*.*" >> $findout
rev $findout | cut -d' ' -f1 | rev > ${findout}.1
grep '\.' ${findout}.1 | rev | cut -d'.' -f1 | rev | sort | uniq -c | sort -nr > $logfile
