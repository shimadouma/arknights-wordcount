#!/bin/bash

## Lonetrail
## ./gen-wordcount-list.sh act25side CW

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <eventid> <stage-prefix>"
    echo ""
    echo "Ex. eventid: act22side"
    exit 1
fi

cd $(cd $(dirname $0); pwd)

export KW=$1
export PREFIX=$2

loc=ja_JP
loc=zh_CN

cat ./$loc/wordcount.json | jq ".${KW}" | \
    grep "activities" | \
    sed -re "s/^ *\"activities\/[^\/]*\/level_[a-z0-9]*_([^\"]*)\": ([0-9]*).*/${PREFIX}-\1 \2/g" | \
    sed -re "s/st/ST-/g" | sed -re "s/_beg/前/g" | sed -re "s/_end/後/g"
