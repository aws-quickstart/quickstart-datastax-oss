#!/usr/bin/env bash
#  1st paramter is the datacenter
dc="$1"
# this function get ths fault domain to use as the rack
function get_rack {
    rack="rack1"

    zone=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
    if [ ! "$zone" ]; then
        rack="rack1"
    else
        rack=$zone
    fi
  echo $rack
}
#
rack=`get_rack`
#getrack_process_id=$!
#wait $getrack_process_id
#echo getrack exited with status $?
echo rack is $rack
#
#
file="/usr/share/dse/conf/cassandra-rackdc.properties"
# backup cassandra-racdc.properties
date=$(date +%F)
backup="$file.$date"
cp $file $backup
# 
cat $file \
| sed -e "s:^\(dc\=\).*:dc\=$dc:" \
| sed -e "s:^\(rack\=\).*:rack\=$rack:" \
| sed -e "s:^\(prefer_local\=\).*:rack\=true:" \
> $file.new
#
mv $file.new $file
chown cassandra $file
chgrp cassandra $file
echo "dse-vm-rack-props ------> exit status $?"
