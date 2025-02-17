if [ -z "$ACTION_RUNNER_LOG_FILE" ]; then
  export ACTION_RUNNER_LOG_FILE="$ACTION_RUNNER_INSTALL_DIR/action-runner-management-log.txt"
fi

$ACTION_RUNNER_INSTALL_DIR/config.sh remove \
    --token $RUNNER_REMOVE_TOKEN >> "$ACTION_RUNNER_LOG_FILE" 2>&1

if [ "$CLEAN_UP_RUNNER_DIR" == "true" ]; then
  rm -rf "$ACTION_RUNNER_INSTALL_DIR"
fi
