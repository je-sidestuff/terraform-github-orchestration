
eval "$(jq -r '@sh "REPO_FULL_NAME=\(.repo_full_name) GITHUB_PAT=\(.github_pat)"')"

export RUNNER_REMOVE_TOKEN="$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_PAT" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO_FULL_NAME/actions/runners/remove-token \
   | jq -r '.token')"

jq -n --arg runner_remove_token "$RUNNER_REMOVE_TOKEN" '{"runner_remove_token":$runner_remove_token}'
