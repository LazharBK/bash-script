#!/bin/bash
# Author lazhar.bk@gmail.com ;)
# ./script.sh src dis ret
#source
src=$1;
#distinction
dis=$2;
#max number of retention
ret=$3;
#filename
srcfile=$(basename -- $src);
srcdir=$(dirname -- $src);
cd $srcdir;
#unique file name
uqname=$srcfile-$(date +%Y%m%d%H%M);
tar -zpcf $dis/$uqname.tar.gz $srcfile;
echo "new backup created in $dis/$uqname";
#tar zczf - $src | lftp ftp://ns3110071.ip-37-187-149.eu:mzJxBsYvkk@ftpback-any-ovh.mybackup.ovh.net:21 -e "cd $dis; put /dev/stdin -o $fname-$(date +%Y%m%d%H%M).tar.gz;quit"
nret=$(find "$dis" -maxdepth 1 -iname "$srcfile*" -type f 2> /dev/null | wc -l);
#nret=$(find "$dis" -iname "$srcfile*" -type f 2> /dev/null | wc -l);
if [ $ret -lt $nret ]; then
	#lfile list of the backup files occurrences
	lfile=$(find "$dis" -maxdepth 1 -iname "$srcfile*" -type f | sort -n)
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
