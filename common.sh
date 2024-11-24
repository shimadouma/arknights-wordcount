

function list_wordcount() {
    local loc=$1
    local kw=$2
    local prefix=$3

    if [[ $kw =~ ^main ]]; then
        # get list of stage name
        stages=($(cat ./ArknightsStoryJson/$loc/wordcount.json | jq ".${kw}" | grep -o '"obt[^"]*"' | sed -e 's/"//g'))

        total=0
        for stage in ${stages[@]}; do
            wordcount=$(cat ./ArknightsStoryJson/$loc/wordcount.json | jq ".${kw}[\"${stage}\"]")
            code=$(cat ./ArknightsStoryJson/$loc/gamedata/story/$stage.json | jq -r ".storyCode")
            storyname=$(cat ./ArknightsStoryJson/$loc/gamedata/story/$stage.json | jq -r ".storyName")
            avgtag=$(cat ./ArknightsStoryJson/$loc/gamedata/story/$stage.json | jq -r ".avgTag")
            echo "${code}${avgtag} ${storyname} ${wordcount}"
            total=$((total + wordcount))
        done
        echo "Total: ${total}"
    else
        cat ./ArknightsStoryJson/$loc/wordcount.json | jq ".${kw}" | \
            grep "activities" | \
            sed -re "s/^ *\"activities\/[^\/]*\/level_[a-z0-9]*_([^\"]*)\": ([0-9]*).*/${prefix}-\1 \2/g" | \
            sed -re "s/st/ST-/g" | sed -re "s/_beg/前/g" | sed -re "s/_end/後/g" | \
            awk "BEGIN{c=0} {x=int(\$2 * $ratio/100)*100; print \$1, x;c+=x} END{print \"Total:\",c}"
    fi
}

function jp_cn_ratio() {
    ./jp-cn-compare.sh | tail -n 1 | awk '{print $3}'
}