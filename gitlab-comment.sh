#!/usr/bin/env bash
set -euo pipefail

GITLAB_BASE_URL="https://gitlab.com/api/v4"
GITLAB_PROJECT_URL="${GITLAB_BASE_URL}/projects/${CI_PROJECT_ID}"
GITLAB_MR_URL="${GITLAB_PROJECT_URL}/merge_requests/${CI_MERGE_REQUEST_IID}"

exec curl \
    -sfSL \
    --retry 3 \
    --retry-connrefused \
    --retry-delay 2 \
    --request POST \
    --header "Private-Token: $GITLAB_ACCESS_TOKEN" \
    --data-urlencode body@- \
    "${GITLAB_MR_URL}/notes"
