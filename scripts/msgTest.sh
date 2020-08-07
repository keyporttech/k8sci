#!/bin/bash
#docker run -it registry.keyporttech.com:30243/lwp-request:0.1.0 -- bash -c
#ls;
SLACK_TITLE=':thumbsup: gitea Pipeline: helm Continuous Intgegration\n\nStatus: success\n\nRepo: <https://git.keyporttech.com:30243/keyporttech/helm-dynamodb|keyporttech/helm-dynamodb>\n\n<https://dashboard.cicd.keyporttech.com:30243/#/namespaces/cicd/pipelineruns/build-pipeline-run-lrn5z|build information>'
SLACK_MESSAGE='`linting...
helm lint
==> Linting .

1 chart(s) linted, 0 chart(s) failed
helm template test ./
---
# Source: dynamodb/templates/serviceaccount.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test-dynamodb
  labels:
    helm.sh/chart: dynamodb-0.1.4
    app.kubernetes.io/name: dynamodb
    app.kubernetes.io/instance: test
    app.kubernetes.io/version: "1.12.0"
    app.kubernetes.io/managed-by: Helm
---
# Source: dynamodb/templates/service.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.


apiVersion: v1
kind: Service
metadata:
  name: test-dynamodb
  labels:
    helm.sh/chart: dynamodb-0.1.4
    app.kubernetes.io/name: dynamodb
    app.kubernetes.io/instance: test
    app.kubernetes.io/version: "1.12.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 8000
      targetPort: 8000
      protocol: TCP
      name: dynamodb
    - port: 8001
      targetPort: 8001
      protocol: TCP
      name: admin
  selector:
    app.kubernetes.io/name: dynamodb
    app.kubernetes.io/instance: test
---
# Source: dynamodb/templates/deployment.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-dynamodb
  labels:
    helm.sh/chart: dynamodb-0.1.4
    app.kubernetes.io/name: dynamodb
    app.kubernetes.io/instance: test
    app.kubernetes.io/version: "1.12.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: dynamodb
      app.kubernetes.io/instance: test
  template:
    metadata:
      labels:
        app.kubernetes.io/name: dynamodb
        app.kubernetes.io/instance: test
    spec:
      serviceAccountName: test-dynamodb
      securityContext:
        {}
      containers:
        - name: dynamodb
          securityContext:
            {}
          image: "amazon/dynamodb-local:1.12.0"
          imagePullPolicy: IfNotPresent
          args: [ "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar", "-dbPath", "/mnt/data" ]
          ports:
            - name: dynamodb
              containerPort: 8000
              protocol: TCP
          readinessProbe:
            tcpSocket:
              port: dynamodb
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: dynamodb
            initialDelaySeconds: 15
            periodSeconds: 20
          resources:
            {}
          volumeMounts:
            - name: dynamodb-data
              mountPath: /mnt/data
        - name: admin
          securityContext:
            {}
          image: "aaronshaf/dynamodb-admin:latest"
          imagePullPolicy: IfNotPresent
          ports:
            - name: dynamodbadmin
              containerPort: 8001
              protocol: TCP
          readinessProbe:
            tcpSocket:
              port: dynamodbadmin
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: dynamodbadmin
            initialDelaySeconds: 15
            periodSeconds: 20
          resources:
            {}
      volumes:
        - name: dynamodb-data
          emptyDir: {}
---
# Source: dynamodb/templates/hpa.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
---
# Source: dynamodb/templates/ingress.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
---
# Source: dynamodb/templates/pvc.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
---
# Source: dynamodb/templates/tests/test-connection.yaml
# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for dynamodb-helm-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

apiVersion: v1
kind: Pod
metadata:
  name: "test-dynamodb-test-connection"
  labels:
    helm.sh/chart: dynamodb-0.1.4
    app.kubernetes.io/name: dynamodb
    app.kubernetes.io/instance: test
    app.kubernetes.io/version: "1.12.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test-success
spec:
  containers:
    - name: wget
      image: busybox
      command: [\'\''wget\'\'']
      args: [\'\''test-dynamodb:8001\'\'']
  restartPolicy: Never
ct lint --validate-maintainers=false --charts .
Linting charts...
Using config file:  /workspace/git-repo/ct.yaml
Version increment checking disabled.
------------------------------------------------------------------------------------------------------------------------
 Configuration
------------------------------------------------------------------------------------------------------------------------
Remote: origin
TargetBranch: master
BuildId:
LintConf: /etc/ct/lintconf.yaml
ChartYamlSchema: /etc/ct/chart_schema.yaml
ValidateMaintainers: false
ValidateChartSchema: true
ValidateYaml: true
CheckVersionIncrement: false
ProcessAllCharts: false
Charts: [.]
ChartRepos: [keyporttech=https://keyporttech.github.io/helm-charts]
ChartDirs: [helm-charts/charts]
ExcludedCharts: []
HelmExtraArgs: --timeout 600s
HelmRepoExtraArgs: []
Debug: false
Upgrade: false
SkipMissingValues: false
Namespace:
ReleaseLabel:
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
 Charts to be processed:
------------------------------------------------------------------------------------------------------------------------
 dynamodb => (version: "0.1.4", path: ".")
------------------------------------------------------------------------------------------------------------------------

"keyporttech" has been added to your repositories
Linting chart \'\''dynamodb => (version: "0.1.4", path: ".")\'\''
Validating /workspace/git-repo/Chart.yaml...
Validation success! 👍
==> Linting .

1 chart(s) linted, 0 chart(s) failed
------------------------------------------------------------------------------------------------------------------------
 ✔︎ dynamodb => (version: "0.1.4", path: ".")
------------------------------------------------------------------------------------------------------------------------
All charts linted successfully
testing...
docker run -v ~/.kube:/root/.kube -v `pwd`:/charts/dynamodb registry.keyporttech.com:30243/chart-testing:0.1.3 bash -c "git clone git@github.com:keyporttech/helm-charts.git; cp -rf /charts/dynamodb helm-charts/charts; cd helm-charts; ct lint-and-install;"
Unable to find image \'\''registry.keyporttech.com:30243/chart-testing:0.1.3\'\'' locally
0.1.3: Pulling from chart-testing
aad63a933944: Pulling fs layer
7e70b59c120f: Pulling fs layer
8ae6f216dd7a: Pulling fs layer
c2e2df25ce7d: Pulling fs layer
956edaa26c37: Pulling fs layer
2516e9b33845: Pulling fs layer
8612a04796e3: Pulling fs layer
562c481b35e5: Pulling fs layer
15208019d081: Pulling fs layer
4ab0ac084f64: Pulling fs layer
ccebe5d686a0: Pulling fs layer
65048c647ec4: Pulling fs layer
e1609871f43f: Pulling fs layer
562c481b35e5: Waiting
15208019d081: Waiting
4ab0ac084f64: Waiting
ccebe5d686a0: Waiting
65048c647ec4: Waiting
e1609871f43f: Waiting
c2e2df25ce7d: Waiting
956edaa26c37: Waiting
2516e9b33845: Waiting
8612a04796e3: Waiting
8ae6f216dd7a: Verifying Checksum
8ae6f216dd7a: Download complete
aad63a933944: Verifying Checksum
aad63a933944: Download complete
c2e2df25ce7d: Verifying Checksum
c2e2df25ce7d: Download complete
aad63a933944: Pull complete
2516e9b33845: Verifying Checksum
2516e9b33845: Download complete
956edaa26c37: Verifying Checksum
956edaa26c37: Download complete
562c481b35e5: Verifying Checksum
562c481b35e5: Download complete
8612a04796e3: Verifying Checksum
8612a04796e3: Download complete
4ab0ac084f64: Verifying Checksum
4ab0ac084f64: Download complete
15208019d081: Verifying Checksum
15208019d081: Download complete
ccebe5d686a0: Verifying Checksum
ccebe5d686a0: Download complete
7e70b59c120f: Download complete
65048c647ec4: Verifying Checksum
65048c647ec4: Download complete
e1609871f43f: Verifying Checksum
e1609871f43f: Download complete
7e70b59c120f: Pull complete
8ae6f216dd7a: Pull complete
c2e2df25ce7d: Pull complete
956edaa26c37: Pull complete
2516e9b33845: Pull complete
8612a04796e3: Pull complete
562c481b35e5: Pull complete
15208019d081: Pull complete
4ab0ac084f64: Pull complete
ccebe5d686a0: Pull complete
65048c647ec4: Pull complete
e1609871f43f: Pull complete
Digest: sha256:a2c4b208337d66374c3d62b2e362a7750ac036d565cbe67fb9b2488b076c2a9e
Status: Downloaded newer image for registry.keyporttech.com:30243/chart-testing:0.1.3
Cloning into \'\''helm-charts\'\''...
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
cp: can\'\''t create directory \'\''helm-charts/charts\'\'': No such file or directory
bash: line 0: cd: helm-charts: No such file or directory
Linting and installing charts...
------------------------------------------------------------------------------------------------------------------------
 Configuration
------------------------------------------------------------------------------------------------------------------------
Remote: origin
TargetBranch: master
BuildId:
LintConf: /etc/ct/lintconf.yaml
ChartYamlSchema: /etc/ct/chart_schema.yaml
ValidateMaintainers: true
ValidateChartSchema: true
ValidateYaml: true
CheckVersionIncrement: true
ProcessAllCharts: false
Charts: []
ChartRepos: []
ChartDirs: [charts]
ExcludedCharts: []
HelmExtraArgs:
HelmRepoExtraArgs: []
Debug: false
Upgrade: false
SkipMissingValues: false
Namespace:
ReleaseLabel: app.kubernetes.io/instance
------------------------------------------------------------------------------------------------------------------------
Error: Error linting and installing charts: Error identifying charts to process: Must be in a git repository
------------------------------------------------------------------------------------------------------------------------
No chart changes detected.
------------------------------------------------------------------------------------------------------------------------
Error linting and installing charts: Error identifying charts to process: Must be in a git repository
make: *** [Makefile:35: test] Error 1
';
export SLACK_MESSAGE="\`\`\`$(echo $SLACK_MESSAGE | sed "s/\"//g" | sed "s/'//g" | sed "s/\`//g" | sed "s/-//g" )\`\`\`"

PAYLOAD=$( cat <<EOT
{
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "$SLACK_TITLE"
      }
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "$SLACK_MESSAGE"
      }
    }
  ]
}
EOT
);


curl -d "$PAYLOAD" -H "Content-Type: application/json" -X POST $SLACK_WEBHOOK
