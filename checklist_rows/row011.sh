#!/bin/bash
# Does the COM directory structure follow the standard: 
# $COMROOT/$NET/$model_ver/$RUN.$PDY?

if (($# != 1)); then
    echo "usage: $0 /path/to/com"
    echo "e.g. $0 /lfs/h1/ops/para/com/rrfs/v1.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi
rownum="011"

logfile=out${rownum}.log
[[ -e "${logfile}" ]] && rm -rf ${logfile}
echo "Checking COM directory structure..."
find $1 -maxdepth 2 -type d | sort > ${logfile}

#for tmpjjob in $(ls $1/jobs/*); do
#    echo $tmpjjob >> ${logfile}
#    grep -e 'cd \$.*$' -e '.*\.sh' -e '.*\.py' -e '.*\.pl' -e '>' \
#         -n $tmpjjob | grep -v 'export .*=' >> ${logfile}
#    echo "" >> ${logfile}
#done
#echo "Output written to ${logfile}"
