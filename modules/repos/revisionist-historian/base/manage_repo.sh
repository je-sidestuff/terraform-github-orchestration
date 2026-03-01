#!/bin/bash

# Description: This script clones a Git repository from an HTTPS URL provided
#              via the REPO_HTTPS_CLONE_URL environment variable, then copies
#              the content of a frame directory into the cloned repository and pushes.

TMP_DIR="/tmp/git_repo_apply_frames_$RANDOM_SUFFIX"

echo "Calling ${0} with action ${ACTION} and random suffix ${RANDOM_SUFFIX}"

clean_up_and_report_failure() {
    rm -rf "$TMP_DIR"
    echo "$1"
    exit 1
}

if [ "$ACTION" == "create" ]; then
  # Create a temporary directory
  mkdir -p "$TMP_DIR"
  if [ ! -d "$TMP_DIR" ]; then
    echo "Failed to create temporary directory $TMP_DIR."
    exit 1
  fi

  # Clone the repository
  git clone "$REPO_HTTPS_CLONE_URL" "$TMP_DIR/repo"

  # Examine the repository
  cd "$TMP_DIR/repo"
  tree
  git status

  if [ $? -ne 0 ]; then
    clean_up_and_report_failure "Failed to clone repository"
  fi
elif [ "$ACTION" == "destroy" ]; then
  rm -rf $TMP_DIR
fi
