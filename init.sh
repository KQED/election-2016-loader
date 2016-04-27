#!/bin/sh
mysql -h $ELECTIONS_DB_HOST -u$ELECTIONS_DB_USER -p$ELECTIONS_DB_PASS election2016 << EOF
DROP TABLE APresults;
CREATE TABLE APresults(officename varchar(30) NOT NULL, seatname varchar(30) NOT NULL, lastupdated varchar(25) NOT NULL, precincts int(4), firstname varchar(25) NOT NULL, lastname varchar(25) NOT NULL, votecount int(10), winner varchar(4));
# show tables;
# describe APresults;
EOF
