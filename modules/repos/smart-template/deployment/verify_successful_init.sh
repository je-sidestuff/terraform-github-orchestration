#!/bin/bash

# Description: This script clones a Git repository from an HTTPS URL provided
#              via the repo_https_clone_url payload, then periodically
#              checks for specific tags ('v0.0.1' or 'failed') for a set duration.

# Usage: ./verify_successful_init.sh <repo_https_clone_url> [timeout_in_seconds]

eval "$(jq -r '@sh "HTTPS_CLONE_URL=\(.repo_https_clone_url) TIMEOUT=\(.timeout)"')"

clean_up_and_report_failure() {
    rm -rf "$TMP_DIR"
    jq -n --arg error "$1" '{"error":$error}'
    exit 0
}

# Create a temporary directory
TMP_DIR=$(mktemp -d /tmp/git_tag_check_XXXXXX)
if [ ! -d "$TMP_DIR" ]; then
  jq -n --arg error "Failed to create temporary directory" '{"error":$error}'
  exit 0
fi

# Clone the repository
git clone "$HTTPS_CLONE_URL" "$TMP_DIR/repo" 2>/dev/null  # Suppress clone output unless you need it for debugging
if [ $? -ne 0 ]; then
  clean_up_and_report_failure "Failed to clone repository"
fi

# Change directory to the cloned repository
cd "$TMP_DIR/repo" || { clean_up_and_report_failure "Could not change directory to repo."; }

# Tag check loop
INTERVAL=5   # seconds
START_TIME=$(date +%s)

while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  # Fetch the latest tags
  git fetch --tags 2>/dev/null

  # Check for the target tags
  if git show-ref --tags | grep -q "refs/tags/v0.0.0"; then
    jq -n --arg tag "v0.0.0" '{"tag":$tag}'
    rm -rf "$TMP_DIR" # Cleanup
    exit 0
  elif git show-ref --tags | grep -q "refs/tags/failed"; then
    clean_up_and_report_failure "Initialization failed."
  fi

  if (( ELAPSED_TIME >= TIMEOUT )); then
    clean_up_and_report_failure "Timeout reached. Tag not found."
  fi

  sleep "$INTERVAL"
done