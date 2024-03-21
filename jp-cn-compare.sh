#!/bin/bash

## ./list-events.sh

cd $(cd $(dirname $0); pwd)

jp_dir=./ArknightsStoryJson/ja_JP
cn_dir=./ArknightsStoryJson/zh_CN

cn_json=`mktemp`
jp_json=`mktemp`

# delete tmp file on exit
trap "rm -f $cn_json $jp_json" EXIT INT TERM HUP

cat $cn_dir/wordcount.json | jq 'map_values(. | map(.) | add)' > $cn_json
cat $jp_dir/wordcount.json | jq 'map_values(. | map(.) | add)' > $jp_json

jpsum=0
cnsum=0

echo -e "#eventid\tCN_wordcount\tJP_wordcount\tratio"
for eventid in $(cat $cn_json | jq -r 'keys|.[]' | egrep '^act|^main|act$'); do
    jp_cnt=$(cat $jp_json | jq -r ".[\"${eventid}\"]" | grep -v null)
    cn_cnt=$(cat $cn_json | jq -r ".[\"${eventid}\"]" | grep -v null)
    ratio=""
    
    if [[ -n $jp_cnt && -n $cn_cnt ]]; then
        jpsum=$((jpsum+jp_cnt))
        cnsum=$((cnsum+cn_cnt))
        ratio=$(echo "scale=4; $jp_cnt/$cn_cnt" | bc)
    fi


    echo -e "$eventid\t$cn_cnt\t$jp_cnt\t$ratio"
done

cat <<EOS

Total for comparable events:
CN: $cnsum
JP: $jpsum

JP/CN ratio: $(echo "scale=4; $jpsum/$cnsum" | bc)
EOS