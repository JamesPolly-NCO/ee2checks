#!/bin/bash
# Have absolute paths to libraries been removed from makefiles?

if (($# != 1)); then
    echo "usage: $0 /path/to/pkg"
    echo "e.g. $0 /lfs/h1/ops/para/package/rrfs.v1.0.0"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

rownum="020"
logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log


# Find instances where external library paths are hardcoded in build. 
# Could be in makefiles or other build scripts.
# What we want is module load X and then use $xxx_INC/abc.h rather than
# hardcoding to apps/prod/../abc.h

findout=${logdir}/out${rownum}.find
find $1/sorc -type f > $findout

grepout=${logdir}/out${rownum}.grep
#TODO: Fix below to handle files with spaces in names.
while IFS="" read -r entry; do
    grep -IH '=/' $entry >> $grepout
done < ${findout}

sed 's/:/ /g' $grepout | grep -v 'sorc\/build' \
                       | grep -v '\.tex ' \
                       | grep -v 'sorc\/.*\/tests\/' \
                       | grep -v '\.eps ' \
                       | column -t -l2 > $logfile

