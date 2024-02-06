#!/bin/bash
[ -n $1 ] && DAY=$1 || DAY=3
[ -n $2 ] && vm_id=$2 || vm_id=101
TIME="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
echo "VM $vm_id snapshot ,backup days:$DAY ,please wait ..."
date=`date +%Y%m%d`
HT=`date +%H`
rmdate=`date -d "$DAY days ago" +%Y%m%d`
if [ `qm listsnapshot $vm_id | grep b$date$HT |wc -l` = 0 ];then
  /usr/sbin/qm snapshot $vm_id b$date$HT
  echo " Create success! Snapshot name b$date$HT ."
 sleep 10
else
 echo "Create failed! Snapshot name b$date$HT already used ."
 sleep 2
fi
if [[ `qm listsnapshot $vm_id | grep b$rmdate |wc -l` > 0 ]];then

  for i in `echo $TIME | awk -F "$HT" '{print $1}' `
    do
       if [[ `qm listsnapshot $vm_id | grep b$rmdate$i |wc -l` = 1 ]] ;then
       /usr/sbin/qm delsnapshot $vm_id b$rmdate$i
       sleep 2
       echo "Delete $vm_id snapshot records: b$rmdate$i ."
       fi
  
    done
fi

echo -ne `date` > /tmp/bak_snapshot.log
