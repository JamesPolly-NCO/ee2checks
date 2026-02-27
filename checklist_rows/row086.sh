#!/bin/bash
# Is pgmout and errfile cat’d to stdout file before being removed from $DATA?


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

rownum="086"
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
runtype="firewx"
outputdir=$1
model=$2

for f in $(ls ${outputdir}/${model}_${runtype}*); do
    echo $f >> ${logfile}
    # count executables used
    # execnt=$(grep -c ${model}\.v.\..*\/exec\/ $f)
    # [[ "$execnt" -eq 0 ]] && echo "CHECK: no execs used" >> $logfile && continue
    # get line of tmp work dir removal
    tmpdata=$(grep -ho 'DATA=/lfs..*' $f | head -n1 | cut -d'=' -f2)
    rmdataline=$(grep -n "rm ..*$tmpdata$" $f | cut -d':' -f1)
    [[ -z $rmdataline ]] && echo "CHECK: no rm of datadir found" >> $logfile
    # count instances of pgm variable definition
    pgmcnt=$(grep -c 'pgm=..*' $f)
    if [[ "$pgmcnt" -gt 0 ]]; then
       grep -ho 'pgm=.*' $f | sort | uniq >> ${logfile}
       tmppgmo=$(grep 'pgmout=' $f | cut -d'=' -f2 | sort | uniq)
       [[ -z $tmppgmo ]] && echo "CHECK: pgmout variable not used" >> $logfile
       for tmpoutfile in ${tmppgmo}; do
           catline=$(grep -n "cat ${tmpoutfile}" $f | cut -d':' -f1)
           [[ -z $catline ]] && echo "FAIL: no cat of pgmout file found" >> $logfile && continue
           [[ "$catline" -gt "$rmdataline" ]] && echo "FAIL: no cat of pgmout before rm $f" >> $logfile
       done
    else
        echo "CHECK: pgm variable not used" >> ${logfile}
        echo "execs used..." >> ${logfile}
        grep ${model}\.v.\..*\/exec\/ $f >> ${logfile}
    fi
    errcnt=$(grep -c 'errfile' $f)
    if [[ "$errcnt" -gt 0 ]]; then
       caterrcnt=$(grep -c 'cat errfile' $f)
       if [[ $caterrcnt -eq 0 ]]; then
           echo "FAIL: no cat of errfile, check for use of err_exit" >> $logfile
       else
           catlines=$(grep -n 'cat errfile' $f | cut -d':' -f1 | sort | uniq)
           for catline in ${catlines}; do
               [[ "$catline" -gt "$rmdataline" ]] && echo "FAIL: no cat of errfile before rm $f" >> $logfile
           done
       fi
    else
        echo "CHECK: no errfile in $f" >> $logfile
    fi
    echo >> $logfile
done
