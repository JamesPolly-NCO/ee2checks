#!/bin/bash
# Has the interpreter’s name been added to the top of ALL interpreted scripts?

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

rownum="037"
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

find $1/. -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" \) > ${logfile}
find ${jobsdir} -type f >> ${logfile}

while read entry; do
    tmpinterp=$(head -n1 $entry)
    [[ $? -eq 0 ]] && echo $entry $tmpinterp >> ${logfile}.1 || echo NO_HEAD $entry >> ${logfile}.1
done < ${logfile}
