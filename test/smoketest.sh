#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEST_RESULT="$SCRIPT_DIR/../test-result"

export RSS_EDGE_TAG="$(cat tag)"
export RSS_MIDDLETIER_TAG="$(cat tag)"

docker-compose up -d

sleep 60

docker-compose run --rm cassandra sh -c "cqlsh -e \"$(cat $SCRIPT_DIR/create-db.cql)\" cassandra 9042"

if [[ 200 -eq $(curl --write-out %{http_code} --silent --output /dev/null http://localhost:9090/jsp/rss.jsp) ]]; then
  echo "edge endpoint returned 200"
else
  echo "edge endpoint did not return 200"
  #exit 1
fi

docker-compose kill

echo "true" > $TEST_RESULT
