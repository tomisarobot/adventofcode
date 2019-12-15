#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"
    question_file=$1
    solution_file=${2:-}

    result_file="$question_file.result"

    target/debug/program "$question_file" | tee "$result_file"

    if [ -f "$solution_file" ]
    then
        if [ "$(which colordiff)" != "" ]
        then
            diff "$solution_file" "$result_file" | colordiff
        else
            diff "$solution_file" "$result_file"
        fi
    fi
)
