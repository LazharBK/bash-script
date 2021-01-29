#!/bin/bash
# author lazhar.bk@gmail.com ;)
# ./script.sh /source /destination retention 2>> error.log

#source
src=$1;
#distinction
dis=$2;
#max number of retention
ret=$3;
#filename
fname=$(basename -- $src);
dname=$(dirname -- $src);
cd $dname;
#unique file name
uqname=$fname-$(date +%Y%m%d%H%M).zip;
zip -rq $dis/$uqname.tar.gz $fname;
echo "new backup created in $dis/$uqname";
#tar czf - $src | lftp ftp://username:password@ftpback-rbx3-543.mybackup.ovh.net:21 -e "cd $dis; put /dev/stdin -o $fname-$(date +%Y%m%d%H%M).tar.gz;quit"
nret=$(find "$dis" -maxdepth 1 -iname "$fname*" -type f 2> /dev/null | wc -l);
#nret=$(find "$dis" -iname "$fname*" -type f 2> /dev/null | wc -l);
if [ $ret -lt $nret ]; then
	#lfile list of the backup files occurrences
	lfile=$(find "$dis" -maxdepth 1 -iname "$fname*" -type f | sort -n)
	#nrm number of backup files that will be removed
	nrm=$(expr $nret - $ret);
	for i in ${lfile[*]}
	do
		if [ $nrm -le 0 ]; then
			break
		fi
		rm $i
		echo "old backup has been removed from $i"
		nrm=$(expr $nrm - 1);
	done
else
	echo "nothing to removed"
fi
