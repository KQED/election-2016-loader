#!/bin/sh

#function for general AP results
function get_ap_results {
  echo "******************results is running********************"
  query=`echo 'DROP TABLE APresults'`
  echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
  query=`echo 'CREATE TABLE APresults(officename varchar(30) NOT NULL, seatname varchar(30) NOT NULL, party varchar(25), lastupdated varchar(25) NOT NULL, precincts int(4), firstname varchar(25), lastname varchar(25) NOT NULL, votecount int(10), electWon int(10), winner varchar(4), createdAt timestamp NOT NULL default now(), updatedAt DATETIME DEFAULT NULL);'`
  echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
  #IFS (internal field separator) is reset
  IFS=
  declare -a urls=($AP_URL'&officeID=P&officeID=S' $AP_URL'&officeID=Z&seatNum=3,7,9,11,13,15,17' $AP_URL'&officeID=Y&seatNum=2,4,10,11,14,15,16,17,18,19,20,21,22,24,25,27,28,29,30' $AP_URL'&officeID=H&seatNum=2,3,5,11,12,13,14,15,17,18,19,20')
  for url in "${urls[@]}"
    do
      #Make GET request to AP API and use jq to format into object
      results=$(curl $url | jq -r ' .races[] | {officeName, seatName} + (.reportingUnits[] | {lastUpdated, precinctsReportingPct} + (.candidates[] | {first, last, party, voteCount, electWon, winner}))')
      #Use jq to replace null values with "null" and transform object into list of values separated by commas
      formatted=`echo $results | jq 'if .seatName == null then .seatName="null" else . end' | jq 'if .electWon == null then .electWon=0 else . end' | jq 'if .winner == null then .winner="null" else . end' | jq -r 'map(.) | @csv'`
      #IFS set for to separate on newline 
      IFS=$'\n'

      for line in $formatted
        do
          # IFS=',' read -r -a array <<< "$line"
          # #Check to see if row already exists in DB
          # exists=`echo 'SELECT EXISTS(SELECT * FROM APresults WHERE (firstname = '${array[4]}' AND lastname = '${array[5]}' AND officename = '${array[0]}'));'`
          # doesexist=$($MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016 -se $exists)
          # #If exists, update existing row with new data
          # if [ "$doesexist" -ge "1" ];then
          #   query=`echo 'UPDATE APresults SET lastupdated='${array[2]}', precincts='${array[3]}', party='${array[6]}', votecount='${array[7]}', winner='${array[8]}' WHERE (lastname = '${array[4]}' AND lastname = '${array[5]}' AND officename = '${array[0]}')'`
          #   echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          # #If doesn't exist, create new row with data
          # else 
            #Create SQL insert query with data received from AP API
            query=`echo 'INSERT INTO APresults (officename, seatname, lastupdated, precincts, firstname, lastname, party, votecount, electWon, winner) VALUES ('$line');'`
            echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          # fi
      done
  done
}

get_ap_results

#function for AP prop results
function get_ap_prop_results {
  echo "******************results prop is running********************"
  #IFS (internal field separator) is reset
  IFS=
  declare -a urls=($AP_URL'&officeid=I')
  for url in "${urls[@]}"
    do
      #Make GET request to AP API and use jq to format into object
      results=$(curl $url | jq -r ' .races[] | {officeName, seatName} + (.reportingUnits[] | {lastUpdated, precinctsReportingPct} + (.candidates[] | {last, party, voteCount, winner}))')
      #Use jq to replace null values with "null" and transform object into list of values separated by commas
      formatted=`echo $results | jq 'if .seatName == null then .seatName="null" else . end' | jq 'if .winner == null then .winner="null" else . end' | jq -r 'map(.) | @csv'`
      #IFS set for to separate on newline 
      IFS=$'\n'

      for line in $formatted
        do
          # IFS=',' read -r -a array <<< "$line"
          # exists=`echo 'SELECT EXISTS(SELECT * FROM APresults WHERE (lastname = '${array[4]}' AND officename = '${array[0]}'));'`
          # doesexist=$($MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016 -se $exists)
          # if [ "$doesexist" -ge "1" ];then
          #   #add firstname field since it doesn't exist in object
          #   newline="${line},'null'"
          #   query=`echo 'UPDATE APresults SET lastupdated='${array[2]}', precincts='${array[3]}', party='${array[5]}', votecount='${array[6]}', winner='${array[7]}' WHERE (lastname = '${array[4]}' AND officename = '${array[0]}')'`
          #   echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          # else 
            nullline=',"null"'
            newline=$line$nullline
            query=`echo 'INSERT INTO APresults (officename, seatname, lastupdated, precincts, lastname, party, votecount, winner, firstname) VALUES ('$newline');'`
            echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          # fi
      done
  done
}

get_ap_prop_results
