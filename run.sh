#!/bin/bash

set -e

fail () {
    echo -e "\033[31m\033[1m${1}\033[0m"
    echo "${1}" > "$WERCKER_REPORT_MESSAGE_FILE"
    exit 1
}

# Check if API key is present
if [ -z "$WERCKER_BUGSNAG_DEPLOY_TRACKING_NOTIFY_API_KEY" ]; then
  fail "Please provide a Bugsnag API key."
fi

# Skip when deploy failed (use as an deploy after step)
if [ "$WERCKER_RESULT" = "failed" ]; then
  return 0
fi

# Skip when stage not applicable for deploy tracking
stage_applicable=0;
IFS=,; for x in $WERCKER_BUGSNAG_DEPLOY_TRACKING_NOTIFY_STAGES; do
  # Don't forget to trim space, just in case the list goes like " foo, bar" etc.
  if [ "${x//[[:space:]]/}" == "$STAGE" ]; then
    stage_applicable=1
  fi
done
if [[ $stage_applicable == 0 ]]; then
  return 0
fi
export BUGSNAG_DEPLOY_TRACKING_API_URL="https://notify.bugsnag.com/deploy"

payload="apiKey=$WERCKER_BUGSNAG_DEPLOY_TRACKING_NOTIFY_API_KEY"
payload=$payload"&releaseStage=$STAGE"
payload=$payload"&repository=$WERCKER_GIT_REPOSITORY"
payload=$payload"&branch=$WERCKER_GIT_BRANCH"
payload=$payload"&revision=$WERCKER_GIT_COMMIT"

# Post the result
RESULT=$(curl -d "$payload" -s "$BUGSNAG_DEPLOY_TRACKING_API_URL" --output "$WERCKER_STEP_TEMP"/result.txt -w "%{http_code}")
cat "$WERCKER_STEP_TEMP/result.txt"

if [ "$RESULT" = "400" ]; then
  fail "There was an error reading the payload."
fi
