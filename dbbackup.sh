#!/bin/bash
#
# Ray's MySQL backup script v.01 Jul 20, 2012
# 

#dayofweek=`/bin/date +%a`
DayOfMonth=`/bin/date +%e`

#echo to see if user/run input ($1) is set, and if so append _<userinput> to save file.
if [ -z "$1" ]; then
  # no user argument, no filename changes
  userversion=""
else
  # append user argument to savefile
  userversion="_$1"
fi

echo $userversion
# works when mysql root has no password

for each in `/usr/bin/mysql -e "show databases" -ss`
 do
##  echo "mysqldump  $each | gzip > /sqlbackup/${each}_${DayOfMonth}${userversion}.sql.gz"
  mysqldump $each | gzip > /sqlbackup/${each}_${DayOfMonth}${userversion}.sql.gz
 done

