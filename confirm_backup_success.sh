#!/bin/bash
#
# Ray's rsnapshot double check
# 01/16/2013 ray@ebh
#

MAILTO="alerts"

function backup_fail_alert {
##echo backup_fail_alert called;echo
##tail -n20 /var/log/rsnapshot
( echo -e "\nLast 20 lines of /var/log/rsnapshot:\n\n"; tail -n20 /var/log/rsnapshot; echo -e "\n\n--message from /root/bin/confirm_backup_success.sh cron on $HOSTNAME -- \n" ) | mail -s "rsnapshot error detected on $HOSTNAME" $MAILTO
exit 1
}

#put last line of log in temp file
tail -n1 /var/log/rsnapshot > /tmp/rsnapshot_lastline.cron

#look for and exit if last backup succeded
[[ `grep "completed successfully" /tmp/rsnapshot_lastline.cron` ]] && exit 0

#if we made it this far send out an alert
backup_fail_alert
