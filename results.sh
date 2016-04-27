#!/bin/sh

IFS=
declare -a urls=('http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Z&seatNum=3,9,11,15&format=json' 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Y&seatNum=4,14,16,24,27&format=json' 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=H&seatNum=17&format=json')
echo 
for url in "${urls[@]}"
  do
    results=$(curl $url | jq -r ' .races[] | {officeName, seatName} + (.reportingUnits[] | {lastUpdated, precinctsReportingPct} + (.candidates[] | {first, last, voteCount, winner}))')
    formatted=`echo $results | jq 'if .winner == null then .winner="null" else . end' | jq -r 'map(.) | @csv'`
    IFS=$'\n'

    for line in $formatted
      do
        query=`echo 'INSERT INTO APresults (officename, seatname, lastupdated, precincts, firstname, lastname, votecount, winner) VALUES ('$line');'`
        echo $query | mysql -h $ELECTIONS_DB_HOST -u$ELECTIONS_DB_USER -p$ELECTIONS_DB_PASS election2016
    done
done


