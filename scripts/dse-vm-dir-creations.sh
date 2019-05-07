#!/usr/bin/env bash
# add user, create dirs on external storage, soft links
useradd cassandra
mkdir -p /data/cassandra/data
mkdir -p /data/cassandra/log
mkdir -p /data/cassandra/log/audit
mkdir -p /data/cassandra/data
mkdir -p /data/cassandra/saved_caches
mkdir -p /data/cassandra/commitlog
mkdir -p /data/cassandra/dse-data
mkdir -p /data/cassandra/hints
mkdir -p /data/cassandra/cdc_raw
mkdir -p /data/cassandra/software
mkdir /var/lib/cassandra
mkdir /var/log/cassandra
mkdir /var/lib/datastax-agent
chown cassandra:cassandra /var/lib/cassandra
chown cassandra:cassandra /var/log/cassandra
chown cassandra:cassandra /var/lib/datastax-agent
chown -R cassandra:cassandra /data/cassandra
chown -R cassandra:cassandra /var/lib/cassandra
ln -s /data/cassandra/commitlog /var/lib/cassandra/commitlog
ln -s /data/cassandra/cdc_raw  /var/lib/cassandra/cdc_raw
ln -s /data/cassandra/data /var/lib/cassandra/data
ln -s /data/cassandra/hints /var/lib/cassandra/hints
ln -s /data/cassandra/saved_caches /var/lib/cassandra/saved_caches
ln -s /data/cassandra/log/audit /var/log/cassandra/audit
ln -s /data/cassandra/log /var/log/cassandra
chown -R cassandra:cassandra /data/cassandra
chmod -R ugo+rw /data/cassandra/data
chmod -R ugo+rw /data/cassandra/log
echo "dse-vm-dir-creation ------> exit status $?"
