#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"

program_run () {
    question_file="$1"
    part="$2"
    answer_file="$question_file.$part.answer"
    result_file="$question_file.$part.result"

    sh program-run.sh "$question_file" "$part" | tee "$result_file"

    if [ -f "$answer_file" ] && [ -s "$result_file" ]
    then
        if [ "$(which colordiff)" != "" ]
        then
            diff "$result_file" "$answer_file" | colordiff
        else
            diff "$result_file" "$answer_file"
        fi
    fi
}

question_file="$1"
part_override="${2:-}"

if [ "$part_override" != "" ]
then
    program_run "$question_file" "$part_override"
else
    program_run "$question_file" 'part1'
    program_run "$question_file" 'part2'
fi

)
