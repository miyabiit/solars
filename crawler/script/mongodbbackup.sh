#!/bin/sh
/usr/bin/mongodump --host localhost --db solarsdb --out /data/mongo/dump/solarsdb-`date +%w`
