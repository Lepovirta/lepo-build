#!/usr/bin/env bash
set -euo pipefail

GH_USERNAME=${GH_USERNAME:-"${CIRCLE_PR_USERNAME:-}"}
GH_REPONAME=${GH_REPONAME:-"${CIRCLE_PR_REPONAME:-}"}
GH_PR_NUMBER=${GH_PR_NUMBER:-"${CIRCLE_PR_NUMBER:-}"}
GH_URL="https://api.github.com/repos/${GH_USERNAME}/${GH_REPONAME}/issues/${GH_PR_NUMBER}/comments"

input_to_json_body() {
    jq -R '{body: (. | tostring)}'
}

send_comment() {
    curl -sSfL -X POST -d @- \
        -H "Authorization: token $GITHUB_TOKEN" \
        "$GH_URL"
}

main() {
    if [ -z "${GH_PR_NUMBER:-}" ]; then
        echo "Not a PR. Skipping." >&2
        return 0
    fi

    if [ -z "${GITHUB_TOKEN:-}" ]; then
        echo "No token found from GITHUB_TOKEN!" >&2
        return 1
    fi

    input_to_json_body | send_comment
}

main "$@"
