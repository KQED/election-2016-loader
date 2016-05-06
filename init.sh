#!/bin/sh
$MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016 << EOF
DROP TABLE APresults;
CREATE TABLE APresults(officename varchar(30) NOT NULL, seatname varchar(30) NOT NULL, lastupdated varchar(25) NOT NULL, precincts int(4), firstname varchar(25) NOT NULL, lastname varchar(25) NOT NULL, votecount int(10), winner varchar(4), createdAt timestamp NOT NULL default now(), updatedAt DATETIME DEFAULT NULL);
# show tables;
# describe APresults;
DROP TABLE SOSresults;
CREATE TABLE SOSresults(seatname varchar(30) NOT NULL, lastupdated varchar(30) NOT NULL, totalprecincts int(4), precinctsreporting int(4), name varchar(50) NOT NULL, affiliation varchar(25), votecount int(10), percentvotes float(4), winner varchar(4), createdAt timestamp NOT NULL default now(), updatedAt DATETIME DEFAULT NULL);
EOF
