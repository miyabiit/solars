#!/bin/sh
cd /data/mongo
/usr/bin/mongodump --host localhost --db solarsdb --out /data/mongo/dump/solarsdb
cd /data/mongo/dump
zip -r solarsdb-`date +%w`.zip solarsdb
rm -rf solarsdb
