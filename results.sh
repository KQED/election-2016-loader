#!/bin/sh

function get_ap_results {
  echo "******************results is running********************"
  #IFS (internal field separator) is reset
  IFS=
  declare -a urls=('http://api.ap.org/v2/elections/2016-06-07?apiKey='$AP_API_KEY'&statePostal=CA&officeID=P&officeID=S&format=json&test=true' 'http://api.ap.org/v2/elections/2016-06-07?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Z&seatNum=3,7,9,11,13,15,17&format=json&test=true' 'http://api.ap.org/v2/elections/2016-06-07?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Y&seatNum=2,4,10,11,14,15,16,17,18,19,20,22,24,25,27,28,29,30&format=json&test=true' 'http://api.ap.org/v2/elections/2016-06-07?apiKey='$AP_API_KEY'&statePostal=CA&officeID=H&seatNum=2,3,5,11,12,13,14,15,17,18,19,20&format=json&test=true')
  for url in "${urls[@]}"
    do
      #Make GET request to AP API and use jq to format into object
      results=$(curl $url | jq -r ' .races[] | {officeName, seatName} + (.reportingUnits[] | {lastUpdated, precinctsReportingPct} + (.candidates[] | {first, last, party, voteCount, winner}))')
      #Use jq to replace null values with "null" and transform object into list of values separated by commas
      formatted=`echo $results | jq 'if .seatName == null then .seatName="null" else . end' | jq 'if .winner == null then .winner="null" else . end' | jq -r 'map(.) | @csv'`
      #IFS set for to separate on newline 
      IFS=$'\n'

      for line in $formatted
        do
          echo $line
          IFS=',' read -r -a array <<< "$line"
          exists=`echo 'SELECT EXISTS(SELECT * FROM APresults WHERE (firstname = '${array[4]}' AND lastname = '${array[5]}' AND officename = '${array[0]}'));'`
          doesexist=$($MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016 -se $exists)
          if [ "$doesexist" -ge "1" ];then
            echo "exists"
            #Create SQL insert query with data received from AP API
            query=`echo 'UPDATE APresults SET lastupdated='${array[2]}', precincts='${array[3]}', party='${array[6]}', votecount='${array[7]}', winner='${array[8]}' WHERE (lastname = '${array[4]}' AND lastname = '${array[5]}' AND officename = '${array[0]}')'`
            echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          else 
            echo "doesn't exist"
            #Create SQL insert query with data received from AP API
            query=`echo 'INSERT INTO APresults (officename, seatname, lastupdated, precincts, firstname, lastname, party, votecount, winner) VALUES ('$line');'`
            echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          fi
      done
  done
}

get_ap_results

function get_ap_prop_results {
  echo "******************results prop is running********************"
  #IFS (internal field separator) is reset
  IFS=
  declare -a urls=('http://api.ap.org/v2/elections/2016-06-07?apiKey='$AP_API_KEY'&statePostal=CA&officeid=I&raceid=8689&format=json&test=true')
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
          IFS=',' read -r -a array <<< "$line"
          exists=`echo 'SELECT EXISTS(SELECT * FROM APresults WHERE (lastname = '${array[4]}' AND officename = '${array[0]}'));'`
          doesexist=$($MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016 -se $exists)
          if [ "$doesexist" -ge "1" ];then
            echo "exists"
            newline="${line},'null'"
            echo $newline
            query=`echo 'UPDATE APresults SET lastupdated='${array[2]}', precincts='${array[3]}', party='${array[5]}', votecount='${array[6]}', winner='${array[7]}' WHERE (lastname = '${array[4]}' AND officename = '${array[0]}')'`
            echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          else 
            echo "doesn't exist"
            nullline=',"null"'
            newline=$line$nullline
            echo $newline
            query=`echo 'INSERT INTO APresults (officename, seatname, lastupdated, precincts, lastname, party, votecount, winner, firstname) VALUES ('$newline');'`
            echo $query | $MYSQL_COMMAND -h $ELECTIONS_DB_HOST --port=$ELECTIONS_DB_PORT --user=$ELECTIONS_DB_USER --password=$ELECTIONS_DB_PASS election2016
          fi
      done
  done
}

get_ap_prop_results
