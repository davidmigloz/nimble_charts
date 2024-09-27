#!/bin/bash

contributor_data=$(curl -s -H "Accept: application/vnd.github.v3+json" \
     "https://api.github.com/repos/Nimblesite/nimble_charts/commits?since=$(date -v-3m +%Y-%m-%dT%H:%M:%SZ)&per_page=100" | \
jq -r '.[] | select(.author != null) | "\(.author.login) \(.author.avatar_url)"' | 
sort | uniq -c | sort -rn | 
awk '{printf "%s %s %s\n", $2, $3, $1}')

echo "| Avatar | Username | Commits |"
echo "|--------|----------|---------|"

echo "$contributor_data" | while read -r username avatar_url commits; do
    echo "| <img src=\"$avatar_url\" width=\"50\" height=\"50\" alt=\"$username\"> | [$username](https://github.com/$username) | $commits |"
done