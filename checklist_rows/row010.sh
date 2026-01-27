#!/bin/bash
# Do all J-job scripts cd to the jobs working directory ($DATA) 
# before running any commands that generate output files 
# (eg, setpdy.sh)?

if (($# != 1)); then
    echo "usage: $0 /path/to/package"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs.v1.0.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi
rownum="010"

logfile=out${rownum}.log
[[ -e "${logfile}" ]] && rm -rf ${logfile}
echo "Checking j-jobs for actions before entering working directory..."
for tmpjjob in $(ls $1/jobs/*); do
    echo $tmpjjob >> ${logfile}
    grep -e 'cd \$.*$' -e '.*\.sh' -e '.*\.py' -e '.*\.pl' -n $tmpjjob >> ${logfile}
    echo "" >> ${logfile}
done
echo "Output written to ${logfile}"
