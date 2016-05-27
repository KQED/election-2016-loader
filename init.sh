#!/bin/sh
echo "******************init is running********************"
$MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS << EOF
CREATE DATABASE IF NOT EXISTS election2016;
USE election2016;
DROP TABLE IF EXISTS APresults;
CREATE TABLE APresults(officename varchar(30) NOT NULL, seatname varchar(30) NOT NULL, party varchar(25), lastupdated varchar(25) NOT NULL, precincts int(4), firstname varchar(25), lastname varchar(25) NOT NULL, votecount int(10), winner varchar(4), createdAt timestamp NOT NULL default now(), updatedAt DATETIME DEFAULT NULL);
EOF
