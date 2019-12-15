#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"; source './_setup'

day=$1

if ! [[ "$day" =~ ^[0-9]+$ ]]
then
    >&2 echo "${BASH_SOURCE[0]} <day>"
    exit 1
fi

prefix="day"
if [ "$day" -lt "10" ]
then
    prefix="${prefix}0"
fi
question_dir="question-files/${prefix}${day}"

mkdir -p "$question_dir"

# copy as cURL
# replace 1 in URL with $day

question_file="$question_dir/input.question"

echo "$question_file"

)
