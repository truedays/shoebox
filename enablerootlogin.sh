#!/bin/bash
#
# enablerootlogin.sh v.04  09292010
# Ray@eboundhost.com
#
#  Temporarily enables root (password based) login for a period of userset $sleeptime time.
#  remember to change the sshdconf file path in $sshdconf
#
# USAGE:  enablerootlogin.sh &
#
# Features:
#   * Ignores comment lines in sshd_config
#   * Reverts changes (re-secures) on user abort (Ctrl-C)
#   * Continues even if user places in backgroud and logs out (re-secures after $sleeptime)
#
# Bugs:
#   * Will not run if sshd_config is not already set securely to "without-password"
#
# ToDo:
#   * Test for cases of multiple lines beginning with PermitRoot...  Unknown results
#

# Adjustable Variables:
sleeptime=1200  #SECONDS 900 = 15 minutes
sshdconf=/etc/ssh/sshd_config

# Simple check to ensure sshd_config is how we expect
if [ "`/bin/grep -e '^PermitRoot' $sshdconf`" != "PermitRootLogin 
without-password" ] ; then
  echo -e "\nERROR--- Disable Root Login before using this script. 
Expected: PermitRootLogin without-password"
 else

# Trap the HUP signal to ignore it
 trap : HUP

# Trap Ctrl-C
 trap "echo -e '\n\nCANCELLED--please run this in the background if you 
with to continue working within this session with root login enabled.'" 
SIGINT SIGTERM

sed -i 's/^PermitRootLogin without-password$/PermitRootLogin yes/g' 
$sshdconf
#echo -e "\n--debug-- \n `/bin/grep -e '^PermitRoot' $sshdconf ` 
\n--debug--"

echo -e "\nNOTICE--root is now enabled on `hostname -f`! Re-disabling 
root login in $(($sleeptime/60)) minutes..."
sleep $sleeptime

sed -i 's/^PermitRootLogin yes$/PermitRootLogin without-password/g' 
$sshdconf
echo -e "\n\nSECURED--root login disabled on `hostname -f`"
echo
#echo -e "\n--debug-- \n `/bin/grep -e '^PermitRoot' $sshdconf ` 
\n--debug--"
fi
