#!/usr/bin/env bash
set -eEu -o pipefail
(cd "$(dirname "${BASH_SOURCE[0]}")"; source './_setup'

# IntCode problem set

sh question-download.sh 2 2019
sh question-download.sh 5 2019
sh question-download.sh 7 2019
sh question-download.sh 9 2019
sh question-download.sh 11 2019
sh question-download.sh 13 2019
sh question-download.sh 15 2019
sh question-download.sh 17 2019
sh question-download.sh 19 2019
sh question-download.sh 21 2019
sh question-download.sh 23 2019
sh question-download.sh 25 2019

)
