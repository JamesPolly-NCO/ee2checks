#!/bin/bash
# Have you checked for zero byte files in the output directories? 
# (And if any were found, did you confirm that an empty file can be expected?).

if (($# != 1)); then
    echo "usage: $0 /path/to/com"
    echo "e.g. $0 /lfs/h1/ops/para/com/rrfs/v1.0/"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="083"
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

echo "Checking enkf..."
tmpcnt=0
for f in $(find ${tmpdir}/enkfrrfs.${chkpdy} -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking rrfsens..."
tmpcnt=0
for f in $(find ${tmpdir}/rrfsens.${chkpdy} -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking rrfs..."
tmpcnt=0
for f in $(find ${tmpdir}/rrfs.${chkpdy} -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking firewx..."
tmpcnt=0
for f in $(find ${tmpdir}/firewx.${chkpdy} -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking HOURLY_HWP..."
tmpcnt=0
for f in $(find ${tmpdir}/HOURLY_HWP/hourly_hwp.${chkpdy} -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking RAVE_INTP..."
tmpcnt=0
for f in $(find ${tmpdir}/RAVE_INTP/rave_intp.${chkpdy} -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking satbias..."
tmpcnt=0
for f in $(find ${tmpdir}/satbias -name "*${chkpdy}*" -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking surface..."
tmpcnt=0
for f in $(find ${tmpdir}/surface -name "*${chkpdy}*" -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"

echo "Checking firewx_input..."
tmpcnt=0
for f in $(find ${tmpdir}/firewx_input/*${chkpdy}* -type f); do
    (( tmpcnt++ ))
    [[ -s $f ]] || echo $f >> $logfile
done
echo "${tmpcnt} files checked"


[[ ! -e $logfile ]] && echo No zero byte output files.

