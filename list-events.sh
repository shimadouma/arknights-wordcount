#!/bin/bash

## ./list-events.sh

cd $(cd $(dirname $0); pwd)

loc=ja_JP

tmp=`mktemp`

trap 'rm -f $tmp' EXIT INT TERM HUP

for loc in ja_JP zh_CN; do
    echo "loc: $loc" >> $tmp
    echo "" >> $tmp

    # list side story event ids
    echo "## Side Story ($loc)" >> $tmp
    for dir in $(find ./ArknightsStoryJson/$loc/gamedata/story/activities/ -maxdepth 1 -mindepth 1 -type d); do
        eventid=$(basename $dir)
        json=$(find $dir -name "*.json" | head -n 1)
        eventname=$(jq -r ".eventName" $json)

        if [[ -n $eventname ]]; then
            echo -e "$eventid\t$eventname" >> $tmp
        fi
    done

    echo "" >> $tmp

    # list main story ids
    echo "## Main Story ($loc)" >> $tmp
    main_story_num=($(find ./ArknightsStoryJson/$loc/gamedata/story/obt/main/ -type f -name "*.json" | grep level_main | sed -e 's!.*/level_main_\([0-9][0-9]*\).*!\1!g' | sed -e 's/^0\([0-9]\)/\1/g' | sort -n | uniq))

    for num in ${main_story_num[@]}; do
        eventid="main_$num"
        json_file_prefix=$(printf "level_main_%02d" $num)
        json_file=$(find ArknightsStoryJson/$loc/gamedata/story/obt/main/ -name "${json_file_prefix}*.json" | head -n 1)
        eventname=$(jq -r ".eventName" $json_file)

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
