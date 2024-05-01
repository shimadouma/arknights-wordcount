

function list_wordcount() {
    local loc=$1
    local kw=$2
    local prefix=$3

    if [[ $kw =~ ^main ]]; then
        cat ./ArknightsStoryJson/$loc/wordcount.json | jq ".${kw}" | \
            sed -re "s!^ *\"obt/main/level_([^\"]*)\": ([0-9]*).*!\1 \2!g" | \
            sed -re "s/st_/ST-/g" | sed -re "s/_beg/前/g" | sed -re "s/_end/後/g" | sed -re "s/main_//g"
    else
        cat ./ArknightsStoryJson/$loc/wordcount.json | jq ".${kw}" | \
            grep "activities" | \
            sed -re "s/^ *\"activities\/[^\/]*\/level_[a-z0-9]*_([^\"]*)\": ([0-9]*).*/${prefix}-\1 \2/g" | \
            sed -re "s/st/ST-/g" | sed -re "s/_beg/前/g" | sed -re "s/_end/後/g"
    fi
}

function jp_cn_ratio() {
    ./jp-cn-compare.sh | tail -n 1 | awk '{print $3}'
}