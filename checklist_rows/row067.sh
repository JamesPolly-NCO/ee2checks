#!/bin/bash
# Do all makefiles have the following targets: all, debug, install and clean?

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

rownum="067"
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

echo "Makefiles missing 'all' target:" >> ${logfile}
for tmpfile in $(find ${sorcdir}/. -name "makefile"); do 
    grep -L 'all:' $tmpfile >> ${logfile}
done
echo "Makefiles missing 'clean' target:" >> ${logfile}
for tmpfile in $(find ${sorcdir}/. -name "makefile"); do 
    grep -L 'clean:' $tmpfile >> ${logfile}
done
echo "Makefiles missing 'debug' target:" >> ${logfile}
for tmpfile in $(find ${sorcdir}/. -name "makefile"); do 
    grep -L 'debug:' $tmpfile >> ${logfile}
done
echo "Makefiles missing 'install' target:" >> ${logfile}
for tmpfile in $(find ${sorcdir}/. -name "makefile"); do 
    grep -L 'install:' $tmpfile >> ${logfile}
done
