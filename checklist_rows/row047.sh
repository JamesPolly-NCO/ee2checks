#!/bin/bash
# For jobs that must have data to run, do they have proper error 
# handling if the needed data types aren’t available (If not, use ‘cpreq’)?

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

rownum="047"
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

grep -r 'cp ' ${ecfdir} ${jobsdir} ${scriptsdir} ${ushdir} >> ${logfile}

echo "Check logfile: ${logfile}..."
echo "Use cpreq if entire job should fail if copy fails..."
echo "If copying data of opportunity, and the job has if check first, using only cp is acceptable."
