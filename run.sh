#!/bin/bash
#GITHUB_REPO_OWNER=""
#GITHUB_REPO=""
#GITHUB_TOKEN=""
#SLACK_WEBHOOK_URL=""

# Calls the Github webhook status URL to check the info.

HOOK_ID=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO/hooks | jq -r .[].id)

WEBHOOK_DELIVERY_LIST=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO/hooks/$HOOK_ID/deliveries)
  
LAST_WEBHOOK_STATUS=$(echo $WEBHOOK_DELIVERY_LIST | jq -r .[0].status)
LAST_WEBHOOK_DELIVERY_ID=$(echo $WEBHOOK_DELIVERY_LIST | jq -r .[0].id)

if [[ "$LAST_WEBHOOK_STATUS" == "OK" ]]; then

    echo "All webhooks went through with no issue."
    echo "Nothing to do!"
    exit 0

else

    echo "It seems like there was an issue at the previous webhook delivery."
    echo "Retriggering the last webhook."

    # Send a slack noti if there's a failed webhook.
    curl -X POST \
        -H 'Content-type: application/json' \
        --data "{'attachments': [ { 'color': '#A569BD', 'title': '📦 There is a failed webhook', 'text': 'There is a failed Github Webhook Payload that hasn\'t delivered. - $GITHUB_REPO_OWNER/$GITHUB_REPO - Delivery ID: $LAST_WEBHOOK_DELIVERY_ID.' } ] }" $SLACK_WEBHOOK_URL


    # Retrigger the failed one
    if command curl -s -L -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN"\
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO/hooks/$HOOK_ID/deliveries/$LAST_WEBHOOK_DELIVERY_ID/attempts; then

      # Send a slack noti for the result.
      echo "Successfully redelivered the webhook."
      curl -X POST \
        -H 'Content-type: application/json' \
        --data "{'attachments': [ { 'color': '#A569BD', 'title': '📦 Successfully redelivered the webhook', 'text': 'Successfully redelivered the webhook - $GITHUB_REPO_OWNER/$GITHUB_REPO.' } ] }" $SLACK_WEBHOOK_URL

    else

      # Send a slack noti for the result.
      echo "Failed to redeliver the webhook."
      curl -X POST \
        -H 'Content-type: application/json' \
        --data "{'attachments': [ { 'color': '#A569BD', 'title': '📦 Failed to redeliver the webhook', 'text': 'Failed to redeliver the webhook. Please check the status. - $GITHUB_REPO_OWNER/$GITHUB_REPO.' } ] }" $SLACK_WEBHOOK_URL

    fi 

fi 