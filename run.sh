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

# Check if release stage is present
if [ -z "$WERCKER_BUGSNAG_DEPLOY_TRACKING_NOTIFY_RELEASE_STAGE" ]; then
  fail "Please provide release stage."
fi

# Skip when deploy failed (use as an deploy after step)
if [ "$WERCKER_RESULT" = "failed" ]; then
  return 0
fi

export BUGSNAG_DEPLOY_TRACKING_API_URL="https://notify.bugsnag.com/deploy"

payload="apiKey=$WERCKER_BUGSNAG_DEPLOY_TRACKING_NOTIFY_API_KEY"
payload=$payload"&releaseStage=$WERCKER_BUGSNAG_DEPLOY_TRACKING_NOTIFY_RELEASE_STAGE"
payload=$payload"&repository=$WERCKER_GIT_REPOSITORY"
payload=$payload"&branch=$WERCKER_GIT_BRANCH"
payload=$payload"&revision=$WERCKER_GIT_COMMIT"

# Post the result
RESULT=$(curl -d "$payload" -s "$BUGSNAG_DEPLOY_TRACKING_API_URL" --output "$WERCKER_STEP_TEMP"/result.txt -w "%{http_code}")
cat "$WERCKER_STEP_TEMP/result.txt"

if [ "$RESULT" = "400" ]; then
  fail "There was an error reading the payload."
fi
