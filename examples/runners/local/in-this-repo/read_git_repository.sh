#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

export FULL_ORIGIN_PATH="$(git ls-remote --get-url origin)"

jq -n --arg full_origin_path "$FULL_ORIGIN_PATH" '{"full_origin_path":$full_origin_path}'
