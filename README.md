# Github Webhook Status Checker

This is a simple project to automatically check your Github repository's webhook status, redeliver it if it has failed, and report the status through Slack.

## How to use

### On VM or Traditional Server

Please make sure to uncomment the environment variables, and put your values in.

```
#GITHUB_REPO_OWNER=""
#GITHUB_REPO=""
#GITHUB_TOKEN=""
#SLACK_WEBHOOK_URL=""
```

You could run the script on the fly by running the command below.

```
bash run.sh
```

If you want to make it run periodically (which is the recommended way), please set a Cronjob.

```
crontab -e

# Running the script every hour.
0 */1 * * * bash /my/folder/location/run.sh
```

### On Docker 

```
docker run --rm -e GITHUB_REPO_OWNER=<YOUR REPO OWNER NAME> -e GITHUB_REPO=<YOUR REPOSITORY NAME> -e GITHUB_TOKEN="YOUR GITHUB ACCESS TOKEN" -e SLACK_WEBHOOK_URL="YOUR SLACK WEBHOOK URL" kycfeel/github-webhook-status-checker
``` 

If you want to make it run periodically (which is the recommended way), please set a Cronjob.

```
crontab -e

# Running the script every hour.
0 */1 * * * docker run --rm -e GITHUB_REPO_OWNER=<YOUR REPO OWNER NAME> -e GITHUB_REPO=<YOUR REPOSITORY NAME> -e GITHUB_TOKEN="YOUR GITHUB ACCESS TOKEN" -e SLACK_WEBHOOK_URL="YOUR SLACK WEBHOOK URL" kycfeel/github-webhook-status-checker
```

### On Kubernetes

Make sure to edit the `helm/values.yaml` file to fill up the values below.

```
githubRepoOwner: 
githubRepo:
githubToken:
slackWebhookURL:
```

To install, run: 

```
helm install github-webhook-status-checker helm/
```



