#!/bin/sh

# echo $AP_API_KEY
# echo 'http://api.ap.org/v2/reports/4a64dd973b614dd4a2b92e78dd33bfd6?apiKey='$AP_API_KEY
# results=$(curl 'http://api.ap.org/v2/reports/4a64dd973b614dd4a2b92e78dd33bfd6?apiKey='$AP_API_KEY)
# results=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Y&format=json') | jq '.races[0]'

# stateSenate=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Z&seatNum=3,9,11,15&format=json' | jq '.races[] | .| {precintsReportingPct: .reportingUnits[].precintsReportingPct, candidateFirst: .reportingUnits[].candidates[].first, candidateLast: .reportingUnits[].candidates[].last, voteCount: .reportingUnits[].candidates[].voteCount, winner: .reportingUnits[].candidates[].winner}')
# stateSenate=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Z&seatNum=3,9,11,15&format=json' | jq '.races[] | seatName as $seatname | {seatName: $seatname})'
# stateAssembly=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Y&seatNum=4,14,16,&format=json' | jq '{lastUpdated: .races[].lastUpdated, precintsReportingPct: .races[].precintsReportingPct}')

IFS=
# stateSenate=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Z&seatNum=3,9,11,15&format=json' | jq -r ' .races[] | {officeName, seatName} + (.reportingUnits[] | {lastUpdated, precinctsReportingPct} + (.candidates[] | {first, last, voteCount, winner}))')
results=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Z&seatNum=3,9,11,15&format=json' | jq -r ' .races[] | {officeName, seatName} + (.reportingUnits[] | {lastUpdated, precinctsReportingPct} + (.candidates[] | {first, last, voteCount, winner}))')
formatted=`echo $results | jq 'if .winner == null then .winner="null" else . end' | jq -r 'map(.) | @csv'`
# formatted=`echo $results | jq -r 'map(.) | @csv'`
IFS=$'\n'

for line in $formatted
  do
    query=`echo 'INSERT INTO test (officename, seatname, lastupdated, precincts, firstname, lastname, votecount, winner) VALUES ('$line');'`
    echo $query | mysql -h $ELECTIONS_DB_HOST -u$ELECTIONS_DB_USER -p$ELECTIONS_DB_PASS election2016
done


