#!/bin/sh
# echo $ELECTIONS_DB_HOST
# echo $ELECTIONS_DB_USER
# echo $ELECTIONS_DB_PASS
# mysql -h $ELECTIONS_DB_HOST -u $ELECTIONS_DB_USER -p $ELECTIONS_DB_PASS << EOF
mysql -h $ELECTIONS_DB_HOST -u$ELECTIONS_DB_USER -p$ELECTIONS_DB_PASS election2016 << EOF
# show databases;
# USE election2016;
CREATE TABLE test(officename varchar(30) NOT NULL, seatname varchar(30) NOT NULL, lastupdated varchar(25) NOT NULL, precincts int(4), firstname varchar(25) NOT NULL, lastname varchar(25) NOT NULL, votecount int(10), winner varchar(4));
show tables;
describe test;
# INSERT into test (officename, seatname, lastupdated, precincts, firstname, lastname, votecount, winner) VALUES ('State Senate', 'District 3', '2015-11-10T11:14:36Z', 100, 'test', 'test', 196,);
# SELECT * FROM test;
EOF
