#!/bin/bash
# Do all ecFlow tasks start with the letter “j”?

if (($# != 3)); then
    echo "usage: $0 /path/to/pkg ecflow_server ecflow_port"
    echo "e.g. $0 /lfs/h1/ops/para/package/rrfs.v1.0.0 cecflow02 14142"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="023"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log
pkgdir=$1
model=$(basename $1 | cut -d'.' -f1)
model_ver=$(basename $1 | cut -d'.' -f2-)

ecfgetout=${logdir}/out${rownum}.ecfgetout
echo "Checking task names ..."
ecflow_client --host=$2 --port=$3 --get=/para/primary/00/${model} > $ecfgetout
ecflow_client --host=$2 --port=$3 --get=/para/primary/06/${model} >> $ecfgetout
ecflow_client --host=$2 --port=$3 --get=/para/primary/12/${model} >> $ecfgetout
ecflow_client --host=$2 --port=$3 --get=/para/primary/18/${model} >> $ecfgetout

grepout=${logdir}/out${rownum}.grep
grep 'task ' $ecfgetout > $grepout
rev $grepout | cut -d' ' -f1 | rev > $logfile
echo "Number of tasks: $(wc -l $logfile)"
echo "Number of tasks beginning with j: $(grep '^j' $logfile | wc -l)"
