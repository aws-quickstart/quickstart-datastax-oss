#!/usr/bin/env bash
# 1st param is cluster name
# 2nd param is datacenter
# 3rd param are seed nodes
#
echo "dse-init starting"
cluster_name=$1
dc=$2
seeds=$3
# create dir where DDAC will live
mkdir /usr/share/dse
cd /usr/share/dse
# install DDAC
tar -xvf /home/ddac/ddac-5.1.12-bin.tar.gz  --strip-components=1 &
dseinit_tar_process_id=$!
wait $dseinit_tar_process_id
echo ddactar exited with status $?

chown -R cassandra:cassandra /usr/share/dse
# no seeds being passed in would be bad - default to private ip
if [ -z "$seeds" ]
then
   seeds=`echo $(hostname -I)`
fi
privip=`echo $(hostname -I)`

# set cassandra.yaml properties
/home/ddac/ddac-aws-install/dse-vm-cassandra-props.sh $seeds $cluster_name $privip &
cprops_process_id=$!
wait $cprops_process_id
echo cassprops exited with status $?

# set cassandra-rackdc.yaml properties
/home/ddac/ddac-aws-install/dse-vm-rack-props.sh $dc &
rack_process_id=$!
wait $rack_process_id
echo rackprops exited with status $?

# 
# update env
sed -e 's|PATH="\(.*\)"|PATH="/usr/share/dse/bin:/usr/share/dse/tools/bin:\1"|g' -i /etc/environment
#

# start DDAC on node
cp /home/ddac/ddac-aws-install/cassandra.service /etc/systemd/system

systemctl enable cassandra &
casseenable_process_id=$!
wait $casseenable_process_id
echo cassenable exited with status $?

echo "cassandra starting" 
systemctl start cassandra &
cassstart_process_id=$!
wait $cassstart_process_id
echo cassstart exited with status $?

echo "cassandra started"

echo "dse-init ------> deploy-dse exit status $?"

