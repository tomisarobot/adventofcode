#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"; source './_setup'

day=$1

if ! [[ "$day" =~ ^[0-9]+$ ]]
then
    >&2 echo "${BASH_SOURCE[0]} <day>"
    exit 1
fi

program_dir="$(day_sortable $day)_rust"

if [ -d "$program_dir" ]
then
    >&2 echo "$program_dir already exists"
    exit 1
fi

sh question-download.sh $day

question_dir="$(question_dir $day)"
question_file="$(question_file $day)"

cargo new "$program_dir" --name program

echo 'structopt = "0.3.5"' >> "$program_dir/Cargo.toml"

rsync -a rust-files/* $program_dir/
rsync -a $question_dir/* $program_dir/

)
