#!/bin/bash

# Function to display usage information
usage() {
  echo -e "\e[1;31mUsage: $0 <solution-path>\e[0m"
  echo -e "\e[1;34mExample: $0 /path/to/solution\e[0m"
  exit 1
}

# Check if a solution path is provided
if [[ -z "$1" ]]; then
  echo -e "\e[1;31mError: Solution path is required.\e[0m"
  usage
fi

SOLUTION_PATH=$(readlink -f $1)
echo -e "\e[1;33mChecking for outdated NuGet packages in '$SOLUTION_PATH'...\e[0m"

# Run the command to get outdated packages in JSON format in the specified solution path
JSON_OUTPUT=$(dotnet list "$SOLUTION_PATH" package --outdated --format json)

# Check if any outdated packages exist
OUTDATED_COUNT=$(echo "$JSON_OUTPUT" | jq '[.projects[].frameworks[]? | .topLevelPackages // [] | length] | add')
echo -e "\e[1;33m$OUTDATED_COUNT outdated packages found. Starting update process...\e[0m"

if [[ "$OUTDATED_COUNT" -eq 0 ]]; then
  echo -e "\e[1;32mNo outdated packages found. Everything is up to date.\e[0m"
  exit 0
fi

CURR_PROJ=""

# Use jq to iterate over each project and its outdated packages
echo "$JSON_OUTPUT" | jq -r '
  .projects[] | 
  .path as $projectPath | 
  .frameworks[]? | 
  .topLevelPackages[]? | 
  select(.resolvedVersion != .latestVersion) | 
  [$projectPath, .id, .latestVersion, .requestedVersion] | @tsv' |
while IFS=$'\t' read -r project package version oldversion; do
  if [[ "$CURR_PROJ" != "$project" ]]; then
    echo -e "\e[1;34mUpdating packages in $project...\e[0m"
    CURR_PROJ="$project"
  fi
  echo -e "\e[1;32m$package $oldversion => $version\e[0m"
  dotnet add "$project" package "$package" --version "$version" | grep "error"
done

echo -e "\e[1;32mAll outdated packages have been updated.\e[0m"

