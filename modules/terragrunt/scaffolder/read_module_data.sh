#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

eval "$(jq -r '@sh "REPO=\(.repo_full_name) BRANCH=\(.branch) MODULE_PATH=\(.path)"')"

export MODULE_DATA="$(curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/${REPO}/${BRANCH}/${MODULE_PATH}/scaffold_metadata.json)"

jq -n --arg module_data "$MODULE_DATA" '{"module_data":$module_data}'
