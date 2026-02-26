#!/bin/bash
# Is the frequency of GOTO’s reduced compared to previous version?

if (($# != 1)); then
    echo "usage: $0 /path/to/pkg/sorc"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs.v1.0.0/sorc"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="028"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpdir=$1

for file in `find ${tmpdir} -name "*.[fF]*" -type f` ; do 
    egrep -iH "go[ ]*to" $file \
        | grep -iv :c \
        | grep -iv :\! > ${logfile}
done 

echo "Number of GOTOs: $(wc -l ${logfile})"
