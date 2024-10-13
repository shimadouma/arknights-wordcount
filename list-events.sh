#!/bin/bash

## ./list-events.sh

cd $(cd $(dirname $0); pwd)

loc=ja_JP

tmp=`mktemp`

trap 'rm -f $tmp' EXIT INT TERM HUP

for loc in ja_JP zh_CN; do
    echo "loc: $loc" >> $tmp
    echo "" >> $tmp
    for dir in $(find ./ArknightsStoryJson/$loc/gamedata/story/activities/ -maxdepth 1 -mindepth 1 -type d); do
        eventid=$(basename $dir)
        json=$(find $dir -name "*.json" | head -n 1)
        eventname=$(jq -r ".eventName" $json)

        if [[ -n $eventname ]]; then
            echo -e "$eventid\t$eventname" >> $tmp
        fi
    done
    echo "" >> $tmp
    echo "" >> $tmp
done

if [[ -z $PAGER ]]; then
    PAGER=less
fi

cat $tmp | $PAGER
