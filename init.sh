#!/bin/sh



# echo $AP_API_KEY
# echo 'http://api.ap.org/v2/reports/4a64dd973b614dd4a2b92e78dd33bfd6?apiKey='$AP_API_KEY
# results=$(curl 'http://api.ap.org/v2/reports/4a64dd973b614dd4a2b92e78dd33bfd6?apiKey='$AP_API_KEY)
# results=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Y&format=json') | jq '.races[0]'
results=$(curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey='$AP_API_KEY'&statePostal=CA&officeID=Y&format=json' | jq '{officeName: .races[].officeName, seatname: .races[].seatName }')
echo "$results"

# function get_init {
#   curl 'http://api.ap.org/v2/elections/2012-11-06?apiKey=$AP_API_KEY&statePostal=CA&officeID=Y&format=json'
# }

# function init_db {
#   CREATE TABLE results(
#     id varchar,
#     lastupdated varchar,
#     officename varchar,
#     seatname varchar,
#     precintsreportingpct numeric,
#     first_name varchar,
#     last_name varchar,
#     votecount int,
#     winner bool
#   ); | mysql -h -U root
# }