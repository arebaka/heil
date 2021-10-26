#!/bin/bash

error() {
	echo $2 >&2
	exit $1
}

usage() {
	cat >&2 <<EOF
Usage: $0 [options...] <lineno> <filenames...>
Type $0 --help for more information
EOF

	exit 1
}

help() {
	cat <<EOF
heil v1.0
An easy tool for output one line with a specified number from a file or one from each file

Usage:
  $0 [options...] <lineno> <filename>
  $0 [options...] <lineno> <filenames...>

Lines are indexed from 1 (1, 2, 3, etc.)
The name of tool (heil) is a play on words head and tail, the names of utils
that previously had to be run through the pipeline to get the same result.

Options:
  -<integer>  - output also some lines before
  +<integer>  - output also some lines after
  +-<integer> - output lines both before and after

if several options of the same sign are specified, they will add up to the total sum.
e.g.
  $0 +2 -4 +3 +-1 -5 90 myfile.sh
will output the line 90, 10 lines before (4 + 1 + 5) and 6 lines after (2 + 3 + 1).
You will see lines 80 to 96.
If the frame is outside real limits of the file, the excess is ignored.
EOF

	exit 0
}




output() {
	local filename=$1
	local lineno=$2
	local before=$3
	local after=$4

	[ ! -e "$filename" ] && error 1 "$0: cannot open '$filename', no such file!"
	[ -d "$filename" ]   && error 2 "$0: error reading '$filename', it is a directory!"
	[ ! -r "$filename" ] && error 3 "$0: error reading '$filename', permission denied!"

	head -q -n $[lineno + after] "$filename" |
	tail -q -n $[before + 1 + after]
}




posargs=()
before=0
after=0

while [ $# -gt 0 ]
do
	if [[ $1 == '-h' || $1 == '--help' ]]
	then help
	elif [[ $1 =~ ^\+-[0-9]+$ ]]
	then
		let before+=${1:2}
		let after+=${1:2}
	elif [[ $1 =~ ^-[0-9]+$ ]]
	then
		let before+=${1:1}
	elif [[ $1 =~ ^\+[0-9]+$ ]]
	then
		let after+=${1:1}
	else
		posargs+=($1)
	fi

	shift
done

[ ${#posargs[@]} -lt 2 ] && usage

[[ ! ${posargs[0]} =~ ^[0-9]+$ ]] && usage

lineno=${posargs[0]}




for i in ${posargs[@]:1}
do output "$i" $lineno $before $after
done
