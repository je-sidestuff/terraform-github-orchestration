if [ -z "$ACTION_RUNNER_LOG_FILE" ]; then
  export ACTION_RUNNER_LOG_FILE="$ACTION_RUNNER_INSTALL_DIR/action-runner-execution-log.txt"
fi

echo "Executing runner at $(date)" >> "$ACTION_RUNNER_LOG_FILE"

timeout "$ACTION_RUNNER_EXECUTION_TIME" "$ACTION_RUNNER_INSTALL_DIR/run.sh" \
  >> "$ACTION_RUNNER_LOG_FILE" 2>&1
  
if [[ $? -eq 124 ]]; then
  echo "Execution completed." >> "$ACTION_RUNNER_LOG_FILE" 2>&1
fi
