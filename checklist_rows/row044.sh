#!/bin/bash
# Have all references to a centralized jlogfile been removed?

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

rownum="044"
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
versionsdir=${tmpdir}/versions

for subdir in $ecfdir $scriptsdir $jobsdir $ushdir $versionsdir; do
    grep -Iir envir= $subdir >> $logfile
    grep -Iir PACKAGEROOT= $subdir >> $logfile
    grep -Iir OPSROOT= $subdir >> $logfile
    grep -Iir job= $subdir >> $logfile
    grep -Iir jobid= $subdir >> $logfile
    grep -Iir NET= $subdir >> $logfile
    grep -Iir RUN= $subdir >> $logfile
    grep -Iir PDY= $subdir >> $logfile
    grep -Iir PDYm#= $subdir >> $logfile
    grep -Iir PDYp#= $subdir >> $logfile
    grep -Iir cyc= $subdir >> $logfile
    grep -Iir cycle= $subdir >> $logfile
    grep -Iir subcyc= $subdir >> $logfile
    grep -Iir DATAROOT= $subdir >> $logfile
    grep -Iir DATA= $subdir >> $logfile
    grep -Iir "HOME$model"= $subdir >> $logfile
    grep -Iir "USH$model"= $subdir >> $logfile
    grep -Iir "EXEC$model"= $subdir >> $logfile
    grep -Iir "PARM$model"= $subdir >> $logfile
    grep -Iir "FIX$model"= $subdir >> $logfile
    grep -Iir COMROOT= $subdir >> $logfile
    grep -Iir COMIN= $subdir >> $logfile
    grep -Iir COMOUT= $subdir >> $logfile
    grep -Iir "COMIN$model"= $subdir >> $logfile
    grep -Iir "COMOUT$model"= $subdir >> $logfile
    grep -Iir DCOMROOT= $subdir >> $logfile
    grep -Iir DCOMIN= $subdir >> $logfile
    grep -Iir DCOMINdatatype= $subdir >> $logfile
    grep -Iir DBNROOT= $subdir >> $logfile
    grep -Iir SENDECF= $subdir >> $logfile
    grep -Iir SENDDBN= $subdir >> $logfile
    grep -Iir SENDDBN_NTC= $subdir >> $logfile
    grep -Iir SENDCOM= $subdir >> $logfile
    grep -Iir SENDWEB= $subdir >> $logfile
    grep -Iir model_ver= $subdir >> $logfile
    grep -Iir module_ver= $subdir >> $logfile
    grep -Iir extmodel_ver= $subdir >> $logfile
    grep -Iir KEEPDATA= $subdir >> $logfile
    grep -Iir MAILTO= $subdir >> $logfile
    grep -Iir MAILCC= $subdir >> $logfile
done

[[ ! -e $logfile ]] && echo log file does not exist
[[ -s $logfile ]] && echo references to envvars found || echo no references to envvars found
