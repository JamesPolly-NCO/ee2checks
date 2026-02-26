#!/bin/bash
# Are all MPMD and/or CFP child processes running in separate 
# sub-directories or other mechanism to ensure multiple processes 
# don’t step on each other?

# See below:
# https://docs.wcoss2.ncep.noaa.gov/doku.php?id=mpmd
#
# MPMD = multiple serial jobs each having 
# MPMD is not simply mpiexec; mpiexec calling a single binary 
# executable is not what is meant by "MPMD"
#
# Use of a config file is likely MPMD and should match
# examples shown at above website.
#
# Use of cfp should match examples at above website.


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

rownum="087"
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
    logfile=${logdir}/out${rownum}.log
    tmp_mpmd=$(grep -n 'mpiexec .*' $f \
        | grep -v '.*=.*mpiexec')
    tmp_cd=$(grep -n 'cd ' $f)
    if [[ "${tmp_mpmd}" == *"configfile"* ]]; then
        logfile=${logdir}/out${rownum}.log.configfile
    elif [[ "${tmp_mpmd}" == *" cfp "* ]]; then
        logfile=${logdir}/out${rownum}.log.cfp
    elif [[ "${tmp_mpmd}" == *"nc_diag_cat.x"* ]]; then
        logfile=${logdir}/out${rownum}.log.ncdiagcat
    elif [[ "${tmp_mpmd}" == *"exe" ]]; then
        logfile=${logdir}/out${rownum}.log.execs
    fi
    echo $f >> ${logfile}
    echo -e "${tmp_mpmd}\n${tmp_cd}" \
        | sort -n \
        | sed 's/:.*+ /: /' >> ${logfile}
    echo "" >> ${logfile}
done
