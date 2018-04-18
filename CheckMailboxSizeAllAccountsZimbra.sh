#!/bin/bash
output="/tmp/accountusage"
domain="yourdomin.com.br"

touch $output

server=`zmhostname`
/opt/zimbra/bin/zmprov gqu $server|grep $domain|awk {'print $1" "$3" "$2'}|sort|while read line
do
usage=`echo $line|cut -f2 -d " "`
quota=`echo $line|cut -f3 -d " "`
user=`echo $line|cut -f1 -d " "`
status=`/opt/zimbra/bin/zmprov ga $user | grep  ^zimbraAccountStatus | cut -f2 -d " "`
echo "$user `expr $usage / 1024 / 1024`Mb `expr $quota / 1024 / 1024`Mb ($status account)" >> $output
done

########################################################################

# After running above commands you will get output in the below format:
# Mailbox size of user@example.com = 5.72 KB
# Mailbox size of user2@example.com = 1.38 KB
# Mailbox size of test@example.com = 0 B
# Mailbox size of test2@mydomain.com = 19.27 MB
# Mailbox size of supporttest@supportlab.in = 162.15 KB
