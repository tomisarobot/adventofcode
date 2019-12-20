#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"; source './_setup'

day=$1

if ! [[ "$day" =~ ^[0-9]+$ ]]
then
    >&2 echo "${BASH_SOURCE[0]} <day>"
    exit 1
fi

cookie="${AOC_COOKIE:-}"

if [ "$cookie" == "" ]
then
    >&2 echo "AOC_COOKIE is not set"
    exit 1
fi

question_dir="$(question_dir $day)"

mkdir -p "$question_dir"

question_file="$(question_file $day)"

if [ -f "$question_file" ]
then
    >&2 echo "$question_file already exists"
else
    curl -s "https://adventofcode.com/2019/day/$day/input" \
        -H "authority: adventofcode.com" \
        -H "cache-control: max-age=0" \
        -H "upgrade-insecure-requests: 1" \
        -H "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36" \
        -H "sec-fetch-user: ?1" \
        -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3" \
        -H "sec-fetch-site: same-origin" \
        -H "sec-fetch-mode: navigate" \
        -H "accept-encoding: gzip, deflate, br" \
        -H "accept-language: en-US,en;q=0.9" \
        -H "cookie: $AOC_COOKIE" \
        --compressed \
    > "$question_file"

fi


)
