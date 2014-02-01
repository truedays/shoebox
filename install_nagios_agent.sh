#!/bin/bash
#
# install nagios user on provided host/IP
#

# assumes logged in as correct user on correct machine (MC)

if [ $# -lt 1 ] 
then 
 echo "incorrect syntax"
 echo " $0 [user@]<HOSTNAME/IP> [ssh port]"
 echo " EX: $0 \"root@1.2.3.4\" 22"
 exit 1
fi

/usr/bin/rsync -Phav -e "/usr/bin/ssh -p ${2:-22}" ~/nagios.tgz ${1}:/home/
/usr/bin/ssh ${1} -p${2:-22} "(adduser nagios && tar xf /home/nagios.tgz && chown -R nagios:nagios /home/nagios; yum install -y glibc.i686 | grep nstalled)"

