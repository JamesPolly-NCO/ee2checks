#!/bin/bash
# Is all code written in C, C++, FORTRAN or Python?

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
rownum="017"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log


findout=${logdir}/out${rownum}.find
echo "Checking file types ..."
find $1/sorc -name "*.*" >> $findout
find $1/ush -name "*.*" >> $findout
rev $findout | cut -d' ' -f1 | rev > ${findout}.1
grep '\.' ${findout}.1 | rev | cut -d'.' -f1 | rev | sort | uniq -c | sort -nr > $logfile
