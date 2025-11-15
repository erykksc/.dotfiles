#!/usr/bin/env bash

if [ -z "$1" ]; then
    github_repos=$(gh repo list)
    echo "${github_repos[@]}"
else
    # If an argument is given (user made a selection), handle it.\
    arg="$1"
    repo_name=$(echo "$arg" | cut -f1)

	(gh browse --repo "$repo_name")
fi
