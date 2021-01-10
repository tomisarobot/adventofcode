#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"; source './_setup'

day=$1
year=$2

if ! [[ "$day" =~ ^[0-9]+$ ]]
then
    >&2 echo "${BASH_SOURCE[0]} <day> <year>"
    exit 1
fi

if ! [[ "$year" =~ ^[0-9]+$ ]]
then
    >&2 echo "${BASH_SOURCE[0]} <day> <year>"
    exit 1
fi

solution_dir="$(solution_dir)"

mkdir -p "$solution_dir"

program_dir="$(day_sortable $day $year)_rust"

if [ -d "$program_dir" ]
then
    >&2 echo "$program_dir already exists"
    exit 1
fi

sh question-download.sh $day

question_dir="$(question_dir $day $year)"
question_file="$(question_file $day $year)"

(cd "$solution_dir"
cargo new "$program_dir" --name program
)

echo 'structopt = "0.3.5"' >> "$solution_dir/$program_dir/Cargo.toml"

rsync -a rust-files/* $solution_dir/$program_dir/
rsync -a $question_dir/* $solution_dir/$program_dir/

)
