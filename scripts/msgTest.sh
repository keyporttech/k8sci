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
        "text": ":no_entry: pipeline gitea helm Continuous Intgegration failure\n\nRepo: <https://git.keyporttech.com:30243/keyporttech/k8sCI|keyporttech/k8sCI>\n\n<https://dashboard.cicd.keyporttech.com:30243/#/namespaces/cicd/pipelineruns/build-pipeline-run-mkhd7|build information>"
      }
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": '\`\`\`linting... helm lint . ==> Linting . [ERROR] Chart.yaml: apiVersion v3 is not valid. The value must be either v1 or v2 [INFO] Chart.yaml: icon is recommended [ERROR] Chart.yaml: chart type is not valid in apiVersion v3. It is valid in apiVersion v2 Error: 1 chart(s) linted, 1 chart(s) failed make: Chart.yaml Makefile README.md crds scripts templates values.yaml [Makefile:20: lint] Error 1\`\`\`'
      }
    }
  ]
}
EOT
);
build-pipeline-run-rvvkb-ci-qjj26-pod-94gsx
curl -d "$PAYLOAD" -H "Content-Type: application/json" -X POST $SLACK_WEBHOOK
