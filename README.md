# k8sCI

K8sci is a simple powerful CI/CD system packaged as a helm chart. It is an implementation of [tekton pipeline](https://github.com/tektoncd/pipeline) [tekton triggers](https://github.com/tektoncd/triggers) and [tekton dashboard](https://github.com/tektoncd/dashboard).

[Tekton pipelines](https://github.com/tektoncd/pipeline) are kubernetes custom resource definitions designed for running tasks and pipelines. The combination of Helm and Tekton pipelines creates a flexible robust pipeline templating mechanism. Everything is a native kubernetes object.

K8sci dogfoods itself and handles its own build and deploy pipeline. Keyporttech uses and exercises k8sci in all of its pipelines so it is production tested, and we immediately fix any issues.

### Features
  * Easy to use and flexible yaml pipeline definitions in a helm values.yaml.
  * A focus on essential cicd functionality: execution, webhooks, and notification.
  * Docker image based.
  * Pipelines only limited by the docker build images used. Supports anything from a simple Makefile to even running github actions.
  * A flexible architecture that can support multiple github source repo types. Currently supports github and gitea.
  * Auto generated pipeline webhook endpoints exposed through a kubernetes ingress controller.
  * Full UI interface through the [tekton dashboard](https://github.com/tektoncd/dashboard)
  * Allows for the development of secure cicd by allowing implementation to be hidden in a docker container.
  * Github commit status notifications per pipeline.
  * Slack webhook notifications.
  * Secrets configured in helm values file generate kubernetes secrets that are expose as environment variables.

### Prerequisites

  1.) A running modern supported version of kubernetes.

  2.) An ingress controller installed on your cluster. This chart was tested and developed against nginx ingress controller, which is easily installed and configured through a [helm chart](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

  3.) [Helm 3](https://v3.helm.sh/docs/intro/install/) installed.


## Getting started

Read the [docs](./docs/README.md)

Define a [pipeline](./docs/PIPELINES.md) then run deploy it with helm:

```bash
helm repo add keyporttech https://keyporttech.github.io/helm-charts/
helm install keyporttech/k8sci -f my_pipeline.yaml
```
or install locally
```bash
# CLONE THIS REPO then:
cd helm/k8sCI && helm install . -f <YOUR_VALUES_FILE>

```
#### [Example pipelines](./examples)

```yaml
cicdPipelines:
  - name: nodejs
    image: keyporttech/node:12.13.0
    ciCommands:
      - execute: "make build"
        setStatus: "build"
    cdCommands:
      - execute: "make deploy"
        setStatus: "deploy"
  - name: golang
    image: keyporttech/golang:1.14.2-alpine
    ciCommands:
      - excute: "make build"
        setStatus: build
    cdCommands:
      - execute: "make deploy"
        setstatus: "deploy"
  - name: helm
    image: keyporttech/chart-testing:0.1.5
    ciCommands:
      - execute: "make lint"
        setStatus: "lint"
      - execute: "make install"
        setStatus: "test"
      - execute: "make check-version"
        setStatus: "version-check"
    cdCommands:
      - execute: "make deploy"
      - setStatus: "deployed"
  - name: github-actions
    image: registry.keyporttech.com:30243/github-actions:0.1.0
    ciCommands:
      - execute: "act"
        setStatus: "github-actions"
    cdCommands:
      - execute: "act"
        setStatus: "github-actions"
```


### A full Example values.yaml

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

notifications:
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
