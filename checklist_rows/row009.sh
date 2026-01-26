#!/bin/bash
# Are all symlinks contained within the application directory 
# ($PACKAGEROOT/$model.$model_ver)?
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

# Find all the links, pull out the link name and target
find $1 -type l -ls | awk '{print $11 " " $12 " " $13}' | sort > out009.find

# Remove lines with a target specified by a relative path (../path/to/file) 
grep -v '\.\.\/' out009.find | column -t > out009.links_to_check
