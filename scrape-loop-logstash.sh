#!/usr/bin/env bash

while :
do
  echo "scraping to logstash."
  ruby parse_and_push.rb | nc -q 30 logstash 7001
  sleep 30
done
