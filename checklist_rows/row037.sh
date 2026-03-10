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

#find $1/. -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" \) > ${logfile}
#find ${jobsdir} -type f >> ${logfile}

find $jobsdir $scriptsdir $ushdir -type f > $logfile

#check to see if script in above listing is:
#a) called by one of the other scripts in the listing
#b) not called at all
while read entry; do
    tmpbase=$(basename $entry)
    tmpcallflag=0
    while read line; do
        #grep: ignore binary files -I; include file names in output -H
        grep -IH $tmpbase $line >> ${logfile}.callrefs
        [[ $? -eq 0 ]] && tmpcallflag=1 
    done < $logfile
    if [[ "$tmpcallflag" -eq 0 ]]; then
        echo $entry >> ${logfile}.notcalled #manually filter to determine what may be non-ops code
    else
        echo $entry >> ${logfile}.called
    fi
done < $logfile

while read entry; do
    tmpinterp=$(head -n1 $entry)
    if [[ $? -eq 0 ]]; then
        echo $entry $tmpinterp >> ${logfile}.called.shebangs #manually check shebangs exist
                                                             #no shebang needed if sourced
                                                             #check usage in logfile.callrefs
    else
        echo $entry >> ${logfile}.called.noshebang
    fi
done < $logfile.called
