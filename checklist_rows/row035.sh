#!/bin/bash
# Have all development blocks of code been removed or minimized?

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

rownum="035"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
#mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpdir=$1

ecfdir=${tmpdir}/ecf
scriptsdir=${tmpdir}/scripts
jobsdir=${tmpdir}/jobs
ushdir=${tmpdir}/ush
sorcdir=${tmpdir}/sorc
fixdir=${tmpdir}/fix

echo "Visually review jobs and scripts..."
echo "less ${jobsdir}/*"
echo "less ${scriptsdir}/*"
