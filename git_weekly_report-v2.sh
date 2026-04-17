#!/bin/bash

current_day=$(date +%j)
authors=()


# uses days since Jan 1st
#command_output=$(git log --since="7 days ago" --pretty=format:"%an %ad" --date=format:"%j")

while read -a line; do
    day=${line[-1]}
    name=${line[0]}

    if [[ $day -le $current_day ]]; then
        authors+=("$name")
	else
		# converts back into human readable date
		echo -n $(date -d "2026-01-01 +$(($day-1)) days" +"%Y-%m-%d") "- " " " "{#authors[@]}"
		printf "%s\n" "${authors[@]}" | sort -u | tr '\n' ' '
		echo
		authors=()
    fi
done < <(git log --since="7 days ago" --pretty=format:"%an %ad" --date=format:"%j")


echo -n $(date -d "2026-01-01 +$(($day-1)) days" +"%Y-%m-%d") "- "
printf "%s\n" "${authors[@]}" | sort -u | tr '\n' ' '
echo
