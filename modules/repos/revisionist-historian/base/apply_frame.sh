#!/bin/bash

# Description: This script clones a Git repository from an HTTPS URL provided
#              via the REPO_HTTPS_CLONE_URL environment variable, then copies
#              the content of a frame directory into the cloned repository and pushes.

TMP_DIR="/tmp/git_repo_apply_frames_$RANDOM_SUFFIX"

echo "Calling ${0} with frame directory ${FRAME_DIR}, and random suffix ${RANDOM_SUFFIX}"

clean_up_and_report_failure() {
    rm -rf "$TMP_DIR"
    echo "$1"
    exit 1
}

# Change directory to the cloned repository
cd "$TMP_DIR/repo" || { clean_up_and_report_failure "Could not change directory to repo."; }
tree
git status

# Copy the frame directory into the cloned repository
echo "Copy from $FRAME_DIR"
ls "$FRAME_DIR"
mv .git ../.git
rm -rf ./*
mv ../.git .git
shopt -s dotglob

# Apply common baseline first (if it exists)
if [ -n "$COMMON_DIR" ] && [ -d "$COMMON_DIR" ]; then
  echo "Applying common baseline from $COMMON_DIR"
  cp -r "$COMMON_DIR"/* . 2>/dev/null || true
fi

# Apply frame-specific content (overwrites common where conflicts exist)
cp -r "$FRAME_DIR"/* .

shopt -u dotglob
if [ $? -ne 0 ]; then
  clean_up_and_report_failure "Failed to copy frame directory"
fi

# Add, commit, and push the changes
git add .
if [ $? -ne 0 ]; then
  clean_up_and_report_failure "Failed to add changes"
fi

git commit -m "$COMMIT_MESSAGE"
if [ $? -ne 0 ]; then
  clean_up_and_report_failure "Failed to commit changes"
fi

git push
if [ $? -ne 0 ]; then
  clean_up_and_report_failure "Failed to push changes"
fi

# If our TAG is set, tag the repository
if [ -n "$TAG" ]; then
  git tag "$TAG"
  if [ $? -ne 0 ]; then
    clean_up_and_report_failure "Failed to tag repository"
  fi
  git push --tags
  if [ $? -ne 0 ]; then
    clean_up_and_report_failure "Failed to push tags"
  fi
fi
