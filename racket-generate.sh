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

example_dir="$(example_dir $day $year)"
question_dir="$(question_dir $day $year)"

solution_dir="$(solution_dir $year)"
program_dir="$(day_sortable $day)_rust"

mkdir -p "$solution_dir"

if [ -d "$solution_dir/$program_dir" ]
then
    >&2 echo "$program_dir already exists"
    exit 1
fi

sh question-download.sh $day $year

mkdir -p "$solution_dir/$program_dir"

shopt -s dotglob
rsync -a racket-files/* $solution_dir/$program_dir/
rsync -a $question_dir/* $solution_dir/$program_dir/
if [ -d "$example_dir" ]
then
    rsync -a $example_dir/* $solution_dir/$program_dir/
fi

)
