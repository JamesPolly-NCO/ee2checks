#!/bin/bash
# Are production utilities used for error handling (err_chk, err_exit)?

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

rownum="053"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpdir=$1
model=$(basename $1 | cut -d'.' -f1)
model_ver=$(basename $1 | cut -d'.' -f2-)

ecfdir=${tmpdir}/ecf
scriptsdir=${tmpdir}/scripts
jobsdir=${tmpdir}/jobs
ushdir=${tmpdir}/ush
sorcdir=${tmpdir}/sorc
fixdir=${tmpdir}/fix

grep -c 'err_chk' ${jobsdir}/* > ${logfile}.chkjobs
grep -c 'err_exit' ${jobsdir}/* > ${logfile}.exitjobs

grep -c 'err_chk' ${scriptsdir}/* > ${logfile}.chkscripts
grep -c 'err_exit' ${scriptsdir}/* > ${logfile}.exitscripts

echo "Jobs that do not call err_chk:"
grep ':0' ${logfile}.chk*
