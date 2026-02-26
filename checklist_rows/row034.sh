#!/bin/bash
# Have all references to developer work areas been removed from scripts?

if (($# != 1)); then
    echo "usage: $0 /path/to/pkg"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs.v1.0.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="034"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpdir=$1

ecfdir=${tmpdir}/ecf
scriptsdir=${tmpdir}/scripts
jobsdir=${tmpdir}/jobs
ushdir=${tmpdir}/ush
sorcdir=${tmpdir}/sorc
fixdir=${tmpdir}/fix

grep -Iir --exclude=*.eps --exclude-dir=${sorcdir} \
    --exclude-dir=${fixdir} --exclude-dir=".*" '\/emc\/' ${tmpdir} \
    | column -t -l2 > ${logfile}
echo "Number of failures : $(wc -l ${logfile})"
