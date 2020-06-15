#!/bin/bash
#docker run -it registry.keyporttech.com:30243/lwp-request:0.1.0 -- bash -c
#ls;

PAYLOAD=$( cat <<EOT
{
    "text": "Hello, world."
}
EOT
);

curl -d "$PAYLOAD" -H "Content-Type: application/json" -X POST $SLACK_WEBHOOK
