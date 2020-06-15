#!/bin/bash
#docker run -it registry.keyporttech.com:30243/lwp-request:0.1.0 -- bash -c
#ls;

PAYLOAD=$( cat <<EOT
{
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": ":thumbsup: gitea success\n\nRepo: <https://git.keyporttech.com:30243/keyporttech/k8sCI|keyporttech/k8sCI>\n\n<https://dashboard.cicd.keyporttech.com:30243/#/namespaces/cicd/pipelineruns/build-pipeline-run-k58wr-ci-bzkv4-pod-6grpv|build information>"
      }
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "test"
      }
    }
  ]
}
EOT
);

curl -d "$PAYLOAD" -H "Content-Type: application/json" -X POST $SLACK_WEBHOOK
