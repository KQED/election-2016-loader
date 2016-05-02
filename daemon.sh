#!/bin/sh

. /election-2016-loader/results.sh

for (( i=1; i < 1000000; i+=1)); do
  results
  sleep $LOADER_TIMEOUT
done