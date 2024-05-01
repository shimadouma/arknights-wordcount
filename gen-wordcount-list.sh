#!/bin/bash

cd $(cd $(dirname $0); pwd)

set -e

source ./common.sh

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
# loc=zh_CN

IS_JP=y
if cat ./ArknightsStoryJson/$loc/wordcount.json | jq ".${KW}" | grep null > /dev/null; then
    IS_JP=n
fi

if [[ $IS_JP = "y" ]]; then
    list_wordcount $loc $KW $PREFIX | awk "BEGIN{c=0} {print \$1, \$2;c+=\$2} END{print \"Total:\",c}"
    exit 0
fi

loc=zh_CN

echo "** JP data not available. Estimate from CN data **"
echo ""
ratio=$(jp_cn_ratio)
list_wordcount $loc $KW $PREFIX | awk "BEGIN{c=0} {x=int(\$2 * $ratio/100)*100; print \$1, x;c+=x} END{print \"Total:\",c}"
