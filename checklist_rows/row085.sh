#!/bin/bash
# Does each executable redirect stdout and stderr to files (pgmout and errfile, for example), 
# except executables with minimum amount of output (100 lines or so)?


if (($# != 1)); then
    echo "usage: $0 /path/to/pkg"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs.v1.0.0/"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="085"
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

chkpdy=20260216

module use /apps/ops/para/nco/modulefiles/core
module load intel python/3.8.6 prod_util gempak util_shared ecflow libjpeg grib_util
module load upgrade_utils

item_57.sh $tmpdir > ${logfile}
