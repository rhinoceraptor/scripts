#!/usr/bin/env bash
# Retrieves a list of git commits you made (excluding merge commits) on a given date

set -e

exit_with_usage () {
	echo "Date not given or not valid"
	echo "Usage: $ show-commits-from  2017-03-02"
	exit 1
}

DAY=$1

if [ -z "$DAY" ]; then
	exit_with_usage
fi

if [[ ! $DAY =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  exit_with_usage
fi

COMMITS=$(git log \
  --after="$DAY 00:00" \
  --before="$DAY 23:59" \
  --author="$(git config --get user.name)" \
  --no-merges \
  --decorate \
  --oneline \
  --source \
  --simplify-merges \
  | cut -f1)

echo "Branches worked on:"

for commit in $COMMITS; do
  git reflog show --all | grep "$commit" | sed 's/^[a-f0-9]\{8\} refs\/heads\/\(.*\)@\(.*\)/\1/p'
done | uniq

