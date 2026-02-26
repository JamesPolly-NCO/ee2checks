#!/bin/bash
# Have the standard file name conventions been followed for new publicly distributed output, 
# i.e., Section IIIb in WCOSS implementation standards documentation?

if (($# != 1)); then
    echo "usage: $0 /path/to/COMmodel"
    echo "e.g. $0 /lfs/h1/ops/para/com/rrfs/v1.0 "
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="024"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpcomdir=$1

find $tmpcomdir -name "*wmo" -type d > ${logfile}

echo "Review filenames in directories listed in ${logfile} for compliance"
