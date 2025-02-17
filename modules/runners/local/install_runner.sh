#!/bin/bash

mkdir -p "$ACTION_RUNNER_INSTALL_DIR"

export ACTION_RUNNER_TAR_FILENAME="actions-runner-linux-x64-2.320.0.tar.gz"
export ACTION_RUNNER_TAR_CHECKSUM="93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900"
if [ -z "$ACTION_RUNNER_LOG_FILE" ]; then
  export ACTION_RUNNER_LOG_FILE="$ACTION_RUNNER_INSTALL_DIR/action-runner-log.txt"
fi

echo "Intalling action runner $ACTION_RUNNER_TAR_FILENAME/$ACTION_RUNNER_TAR_CHECKSUM to $ACTION_RUNNER_INSTALL_DIR" \
  >> "$ACTION_RUNNER_LOG_FILE"

if [ -n "$ACTION_RUNNER_LOCAL_CACHE_DIR" ]; then
  mkdir -p "$ACTION_RUNNER_LOCAL_CACHE_DIR"
  if [ -f "$ACTION_RUNNER_LOCAL_CACHE_DIR/$ACTION_RUNNER_TAR_FILENAME" ]; then
    echo "Copying runner from cache $ACTION_RUNNER_LOCAL_CACHE_DIR/$ACTION_RUNNER_TAR_FILENAME" \
      >> "$ACTION_RUNNER_LOG_FILE"
  else
    echo "Downloading and copying through cache $ACTION_RUNNER_LOCAL_CACHE_DIR/$ACTION_RUNNER_TAR_FILENAME" \
      >> "$ACTION_RUNNER_LOG_FILE"
    curl -o "$ACTION_RUNNER_LOCAL_CACHE_DIR/$ACTION_RUNNER_TAR_FILENAME" \
      -L https://github.com/actions/runner/releases/download/v2.320.0/$ACTION_RUNNER_TAR_FILENAME
  fi
  cp "$ACTION_RUNNER_LOCAL_CACHE_DIR/$ACTION_RUNNER_TAR_FILENAME" .
else
  echo "Downloading directly." >> "$ACTION_RUNNER_LOG_FILE"
  curl -o $ACTION_RUNNER_TAR_FILENAME -L https://github.com/actions/runner/releases/download/v2.320.0/$ACTION_RUNNER_TAR_FILENAME
fi

echo "$ACTION_RUNNER_TAR_CHECKSUM $ACTION_RUNNER_TAR_FILENAME" | shasum -a 256 -c

echo "Checksum matches - installing to $ACTION_RUNNER_INSTALL_DIR" >> "$ACTION_RUNNER_LOG_FILE"

tar xzf ./$ACTION_RUNNER_TAR_FILENAME -C $ACTION_RUNNER_INSTALL_DIR >> "$ACTION_RUNNER_LOG_FILE" 2>&1

export RUNNER_CONFIG_TOKEN="$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_PAT" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO_FULL_NAME/actions/runners/registration-token \
   | jq -r '.token')"

echo "Calling $ACTION_RUNNER_INSTALL_DIR/config.sh --url https://github.com/$REPO_FULL_NAME \
  --token $RUNNER_CONFIG_TOKEN \
	--name $RUNNER_NAME \
	--runnergroup $RUNNER_GROUP \
	--labels $LABELS_CSV \
	--work $WORK_DIR \
	--unattended" >> "$ACTION_RUNNER_LOG_FILE"

$ACTION_RUNNER_INSTALL_DIR/config.sh --url https://github.com/$REPO_FULL_NAME \
  --token $RUNNER_CONFIG_TOKEN \
	--name $RUNNER_NAME \
	--runnergroup $RUNNER_GROUP \
	--labels $LABELS_CSV \
	--work $WORK_DIR \
	--unattended \
  >> "$ACTION_RUNNER_LOG_FILE" 2>&1
