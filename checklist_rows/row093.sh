#!/bin/bash
# Have you documented DCOM dependencies?  (including versions for deps.py!)

if (($# != 2)); then
    echo "usage: $0 /path/to/output/pdy model"
    echo "e.g. $0 /lfs/h1/ops/para/output/20260101 rrfs"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="093"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
tmpdir=$1

#ecfdir=${tmpdir}/ecf
#scriptsdir=${tmpdir}/scripts
#jobsdir=${tmpdir}/jobs
#ushdir=${tmpdir}/ush
#sorcdir=${tmpdir}/sorc
#fixdir=${tmpdir}/fix

runtype="firewx"
outputdir=$1
model=$2

for f in $(ls ${outputdir}/${model}_${runtype}*); do
    tmpchk=$(grep -iho '\/lfs\/h1\/ops\/p...\/dcom\/.*' $f)
    if [[ -n ${tmpchk} ]]; then
        echo $f >> ${logfile}
        echo -e "${tmpchk}" >> ${logfile}
        echo "" >> ${logfile}
    fi
done

grep -v '\/lfs\/h1\/.*\/output\/' ${logfile} > ${logfile}.nolog
sed 's/ .*//' ${logfile}.nolog > ${logfile}.nolog.nospace
cut -c-70 ${logfile}.nolog.nospace | sort | uniq > ${logfile}.cut
