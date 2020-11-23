# k8sCI
![Version: 0.1.14](https://img.shields.io/badge/Version-0.1.14-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.15.0](https://img.shields.io/badge/AppVersion-0.15.0-informational?style=flat-square)
### tekton:

![pipeline: v0.18.1](https://img.shields.io/badge/pipeline-v0.18.1-informational?style=flat-square)
![triggers: trigggerVer](https://img.shields.io/badge/triggers-v0.9.1-informational?style=flat-square)
![dashboard: v0.11.1](https://img.shields.io/badge/dashboard-v0.11.1-informational?style=flat-square)

A simple kubernetes cicd system based on tektoncd

**Homepage:** <https://github.com/keyporttech/helm-k8sci>

## Introduction

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

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm uninstall my-release -n my-namespace
```

All resources associated with the last release of the chart as well as its release history will be deleted.

#### [Example pipelines](./examples)
```yaml
cicdPipelines:
  - name: nodejs
    protectedBranch: main
    image: node:12.13.0
    ciCommands:
      - execute: "make build"
        setStatus: "build"
    cdCommands:
      - execute: "make deploy"
        setStatus: "deploy"
  - name: golang
    protectedBranch: master
    image: keyporttech/golang:1.14.2-alpine
    ciCommands:
      - excute: "make build"
        setStatus: build
    cdCommands:
      - execute: "make deploy"
        setstatus: "deploy"
  - name: helm
    image: keyporttech/chart-testing:0.1.5
    protectedBranch: main
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
    protectedBranch: main
    image: registry.example.com/github-actions:0.1.0
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
    protectedBranch: main
    image: node:12.13.0
    ciCommand: "make build"
    cdCommand: "make deploy"
  - name: golang
    protectedBranch: master
    image: registry.example.host.com/golang:1.14.2-alpine
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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cicdPipelines | list | `[]` | Array of pipeline definition see docs |
| cleaner.maxJobsToKeep | int | `200` | max number of jobs to keep. Cleaner will remove hte oldeest job in excess of this number. |
| cleaner.schedule | string | `"12 * * * *"` | schedule for job cleaner |
| fullnameOverride | string | `""` | override chart fullname |
| gitSources.gitea | bool | `false` | if true create gitea tekcton event listener with associated ingress |
| gitSources.github | bool | `true` | if true create github tekcton event listener with associated ingress |
| giteaInterceptor | object | `{"image":"keyporttech/gitea-webhook-interceptor:0.1.1"}` | gitea tekton interceptor image for decoding gite hook payloads |
| imagePullSecrets | list | `[]` | image pull secrets for all images |
| ingress.annotations | object | `{}` | ingress annotations |
| ingress.dashboardHost | string | `"dashboard.chart-example.local"` | ingress host for dashboard |
| ingress.dashboardURL | string | `"https://dashboard.chart-example.local:<PORT>"` | URL used in generation of pipeline messaging |
| ingress.enabled | bool | `false` | enabled ingress generation |
| ingress.host | string | `"chart-example.local"` | ingress host name |
| nameOverride | string | `""` | override chart name |
| notifications.slackWebhook | string | `nil` |  |
| pipelineEnvSecrets | list | `[]` | array of secrest stored as a k8s secret and set as an env variable in each pipeline |
| pullPolicy | string | `"IfNotPresent"` | pull policy for all images |
| securityContext | object | `{}` |  |
| serviceAccount.annotations | object | `{}` | generated service account annotations |
| task-resources | object | `{}` |  |
| webhookSecretToken | string | `"token_used_by_gihub/gitea"` | secrets use to encode/decode all webhooks - must also be configured through github/gitea hook settings |

## Source Code

* <https://github.com/tektoncd/pipeline>
* <https://github.com/tektoncd/triggers>
* <https://github.com/tektoncd/dashboard>
* <https://github.com/keyporttech/gitea-tekton-interceptor>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| John Felten | john.felten@gmail.com |  |

## Contributing

Please see [keyporttech charts contribution guidelines](https://github.com/keyporttech/helm-charts/blob/master/CONTRIBUTING.md)

