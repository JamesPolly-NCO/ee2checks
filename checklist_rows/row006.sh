#!/bin/bash
# Has the NCO script naming convention been followed? 
# (top level script called JXXXX which calls one or more executable 
# scripts called exXXXX.[sh | py | pl]):
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

model=$(basename $1 | cut -d'.' -f1)
jprefix=J${model^^}

jjoblist=($1/jobs/*)
echo "Checking j-jobs for naming and use of ex-scripts"
for tmpelem in "${!jjoblist[@]}"; do
    tmpjjob=${jjoblist[$tmpelem]}
    tmpfailflag=0
    tmpprefix=$(basename $tmpjjob | cut -d'_' -f1)
    if (( tmpprefix != jprefix )) ; then
        tmpfailflag=1
        echo "Failed, $tmpjob prefix should be $jprefix"
    fi
    tmpscriptcnt=$(grep -e ex${model}.*\.sh -e ex${model}.*\.py -e ex${model}.*\.pl $tmpjjob | wc -l)
    if (( tmpscriptcnt  < 1 )) ; then
        tmpfailflag=1
        echo "Failed, $jprefix not referenced in $tmpecf"
    fi
    if (( tmpfailflag == 0 )) ; then
        echo "Good: $tmpjjob"
    fi
done

#declare -a ecflist
#for tmpecf in $(find $1/ecf -name "*.ecf"); do
#    ecflist+=($tmpecf)
#done
#echo "${ecflist[0]}"
#echo "${ecflist[1]}"
#echo "${ecflist[2]}"

echo "Checking ecf job cards for use of j-jobs"
for tmpecf in $(find $1/ecf -name "*.ecf"); do
    tmpjobcnt=$(grep $jprefix $tmpecf | wc -l)
    if (( tmpjobcnt != 1 )) ; then 
        echo "Failed, $jprefix not referenced in $tmpecf"
    fi
done
