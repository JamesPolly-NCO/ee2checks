#!/bin/bash
# Is vertical structure implemented according to NCO standards?
if (($# != 1)); then
    echo "usage: $0 /path/to/package"
    exit
fi

if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi

stds_list=("doc"\
 "ecf"\
 "exec"\
 "fix"\
 "gempak"\
 "jobs"\
 "lib"\
 "modulefiles"
 "parm" \
 "parm/wmo"\
 "scripts"\
 "sorc"\
 "ush"\
 "versions"\
)

#echo "${stds_list[@]}"
check_list=($1/*)

paste <(printf "%s\\n" "${check_list[@]}") <(printf "%s\\n" "${stds_list[@]}") | column -t
