#!/bin/bash
# Is the output free of syntax errors and other common errors 
# (syntax error, argument expected, no such file or directory, etc)?

if (($# != 2)); then
    echo "usage: $0 /path/to/output model"
    echo "e.g. $0 /lfs/h1/ops/para/output/20260101 rrfs"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="049"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpdir=$1
tmpmodel=$2

grep -e 'No such file or directory' \
     -e 'Syntax error' \
     -e 'Argument expected' ${tmpdir}/${tmpmodel}_firewx* > ${logfile}

