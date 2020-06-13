# k8sCI

This is the CI/CD system in use at keyporttech. It is an implementation of [tekton/pipeline](https://github.com/tektoncd/pipeline) [tekton/trigger](https://github.com/tektoncd/triggers) packaged into a helm chart.

[Tekton pipelines](https://github.com/tektoncd/pipeline) are kubernetes custom resource definitions designed specifically for running jobs and pipelines.The combination of Helm and Tekton pipelines creates a flexible robust pipeline templating mechanism. Pipelines are defined in a helm values.yaml file:
  * name: name of the pipeline
  * image: docker image that runs the build
  * ciCommands: array of commands to run on git push events ex: - make build, but can be anything
  * cdCommands: array of commands to run when code is pushed to master. Ex: - make deploy

Example:

```yaml
cicdPipelines:
  - name: nodejs
    image: registry.keyporttech.com/node:12.13.0
    ciCommand: "make build"
    cdCommand: "make deploy"
  - name: golang
    image: registry.keyporttech.com/golang:1.14.2-alpine
    ciCommand: "make build"
    cdCommand: "make deploy"
```

The chart exposes pipelines as webhook endpoints through an ingress. Different  uris are generated for github and gitea. Using the above pipeline an ingress controller using tls would generate the following:
  * https://host/gitea/golang
  * https://host/gitea/nodejs
  * https://host/github/golang
  * https://host/github/nodejs

Separate /gitea and /github endpoints are needed because the webhook payloads are different. Currently only github and gitea are supported, but other git hosting services could be easily added. (PRs would are appreciated)

To use k8sCI you need to: install tecton pipeline, triggers, dashboard, install the k8sCI helm chart with the build image configured in the yaml, add web hooks to your source repo. k8sCI has been tested with both public github and gitea running on kuberenetes 1.18 on a bare-metal cluster.
A k8s cluster with an ingress controller is mandatory for k8sci.

k8sCI provides and excellent starting point if further customization is needed. You would need to modify the tekton components, but it should save a lot of time in set up.


## Installation


### prerequisites

1.) A running modern supported version of kubernetes. An ingress controller is required. This chart was tested and developed against nginx ingress controller, which is easily installed and configured through a [helm chart](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

2.) Tekton CRDs installed on the cluster. The tekton CRDs are deliberately left out of the helm chart, since they have their own install distributions and are evolving rapidly. They will be included as part of the chart in later releases.

```bash
# pipelines
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# triggers
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# dashboard
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.6.1/tekton-dashboard-release.yaml

```

3.) (Helm 3)[https://v3.helm.sh/docs/intro/install/] installed.

### install k8sCI helm chart

```bash
# CLONE THIS REPO then:
cd helm/k8sCI && helm install . -f <YOUR_VALUES_FILE>

```

## Configuration and usage

### Ingress configuration

An ingress controller is required by k8sci since ingress endpoints are generated based on pipeline settings. A separate ingress is generated for the tekton dashboard.

example ingress yaml values:

```yaml
ingress:
  enabled: true
  host: cicd.host.com
  dashboardHost: dashboard.host.com
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/ingress.allow-http: "false"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
```


### Enabling Slack notifications

If configured k8sci can send notifications using a (slack webhook)[https://api.slack.com/messaging/webhooks]. This can be configured as follows in your values.yaml:

```yaml
slack-notify:
  slack-webhook: "https://hooks.slack.com/services/TTTTTTTTT/B011111111111111111111111111111111"
```

### Example values.yaml

```yaml
gitSources:
  gitea:
    apiEndPoint: https://git.host.com/api/v1
  github:
    apiEndPoint:  https://api.github.com

cicdPipelines:
  - name: nodejs
    image: registry.host.com/node:12.13.0
    ciCommand: "make build"
    cdCommand: "make deploy"
  - name: golang
    image: registry.host.com/golang:1.14.2-alpine
    ciCommand: "make build"
    cdCommand: "make deploy"

ingress:
  enabled: true
  host: cicd.host.com
  dashboardHost: dashboard.host.com
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/ingress.allow-http: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    kubernetes.io/tls-acme: "true"

slack-notify:
  slack-webhook: "https://hooks.slack.com/services/TTTTTTTTT/B011111111111111111111111111111111"

pipelineEnvSecrets:
  - name: GITHUB_USER
    value: bot-user
  - name: GITEA_USER
    value: bot-user
  - name: GITHUB_TOKEN
    value: AAAAAAAA
  - name: GITEA_TOKEN
    value: AAAAAAAAAAAA

webhookSecretToken: k8sRocks!

gitAuthSsh:
  hosts:
    - "host_dns_or_ip:<PORT>"
  sshPrivatekey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    AAAAAAAAAAAAAAAAAA....
    -----END OPENSSH PRIVATE KEY-----

  known_hosts: |-
    [host.com]:<PORT>,[##.##.##.##]:<PORT22 ecdsa-sha2-nistp256 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA...=
```
