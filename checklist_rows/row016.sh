#!/bin/bash
# Is all output written to $DATA or $COMOUT? (Never DCOM!)?
if (($# != 2)); then
    echo "usage: $0 pkgdir PDY"
    echo "e.g. $0 /lfs/h1/ops/para/packages/rrfs/v1.0.0 20260123"
    exit
fi
    
if [ -d $1 ]; then
    echo "Checking: $1"
else
    echo "$1 does not exist" && exit
fi
rownum="016"

logdir=out${rownum}
[[ -d "${logdir}" ]] && rm -rf ${logdir}
mkdir $logdir
logfile=${logdir}/out${rownum}.log

pkgdir=$1
model=$(basename $1 | cut -d'.' -f1)
model_ver=$(basename $1 | cut -d'.' -f2-)
comoutdir=/lfs/h1/ops/para/com/${model}/${model_ver}/
dcomdir=/lfs/h1/ops/prod/dcom
flashdir=/lfs/f1/ops/para/tmp
appsdir=/apps/ops/prod
pdy=$2
outputlogdir=/lfs/h1/ops/para/output/${pdy}

echo "Checking for output write locations..."

i=0
#for tmpout in $(ls ${outputlogdir}/${model}_* | head -n 100); do
for tmpout in $(ls ${outputlogdir}/${model}_*); do
    i=$((i + 1))
    tmplog=${logdir}/out${rownum}.$i
    [[ -e "${tmplog}" ]] && rm -rf ${tmplog}

    datadir=$(grep 'DATA=\/..*$' $tmpout | rev | cut -d' ' -f1 | rev | head -n1 | cut -d'=' -f2)

    # get the target/destination from copy commands
    #grep -oh ' cp ..*' $tmpout | sed 's/^ //' | rev | cut -d' ' -f1 | rev > ${tmplog}
    grep -oh ' cp ..*' $tmpout | sed 's/^ //' > ${tmplog}

    # get the target/destination from mv commands
    #grep -oh ' mv ..*' $tmpout | sed 's/^ //' | rev | cut -d' ' -f1 | rev >> ${tmplog}
    grep -oh ' mv ..*' $tmpout | sed 's/^ //' >> ${tmplog}

    # get the target/destination from rsync commands
    #grep -oh ' rsync ..*' $tmpout | sed 's/^ //' | rev | cut -d' ' -f1 | rev >> ${tmplog}
    grep -oh ' rsync ..*' $tmpout | sed 's/^ //' >> ${tmplog}

    # get the target/destination from ln commands
    #grep -oh ' ln ..*' $tmpout | sed 's/^ //' | rev | cut -d' ' -f2 | rev >> ${tmplog}
    grep -oh ' ln ..*' $tmpout | sed 's/^ //' >> ${tmplog}

    echo $i $tmpout >> $logfile
    while IFS='\n' read entry; do
    	case "$entry" in
    		*$appsdir* )
    			continue
    		        ;;
    		*$flashdir* )
    			continue
    		        ;;
    		*$datadir* )
    			continue
    		        ;;
    		*$pkgdir* )
    			continue
    		        ;;
    		*$comoutdir* )
    			continue
    		        ;;
    		*$dcomdir* )
    			echo "fail on dcom: $entry" >> $logfile
    		        ;;
    	        *)
                        #skip file ops within work dir (i.e, no path; e.g. mv file1 file2)
                        nonworkdircmd=$(echo $entry | grep '\/')
                        if [[ -n "${nonworkdircmd}" ]]; then
                            echo "not captured: $entry" >> $logfile
                        fi
    	esac
    done < ${tmplog}
done
