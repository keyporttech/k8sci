# k8sci Documentation

## Contents

* [Tekton Dependencies](#tekton-dependencies)
* [Other Dependencies](#gitea-dependencies)
* [Contributing](#contributing)
* [Pipelines](./PIPELINES.md)
* [Git commit statuses](./PIPELINES.md)(:name=git-commit-statuses)
* [Pipeline Secrets](./PIPELINES.md#secrets)
    * [git ssh config](./PIPELINES.md#ssh-config)
* [Pipeline Examples](./PIPELINES.md#examples)
* [Ingress Config and Webhooks](./INGRESS_ENDPOINTS.md#ingress-config)
* [Git Sources](./INGRESS_ENDPOINTS.md#git-sources)
* [Dashboard Ingress](./INGRESS_ENDPOINTS.md)
* [Webhook Endpoints](./INGRESS_ENDPOINTS.md)
* [Configuring a gitub/gitea webhooks](./INGRESS_ENDPOINTS.md#gitea-and-github-webhook-configuration)
* [Examples](../examples/)
  * [a simple golang pipeline](../examples/golang_pipeline)
  * [a pipeline for helm charts](../examples/helm-chart-pipeline)
  * [a pipeline that runs github actions](../examples/github_actions)

[Chart Values](#chart-values)

## Tekton dependencies
Managing crd dependencies, which are not templated, in a helm chart can be tricky.

This chart uses and includes crds, which are the versioned release files supplied by [tekton pipeline](https://github.com/tektoncd/pipeline) [tekton trigger](https://github.com/tektoncd/triggers) and [tekton dashboard](https://github.com/tektoncd/dashboard). Since tekton releases often and sometimes with breaking changes we pin a k8sci release to specific versions of tekton pipelines, tekton triggers and tekton dashboard. The specific crd files are included in the crds directory with the version appended as a file name suffix. Please note that deleting this chart will not remove the dependencies since they are not templated. Also changing the version of the CRDs outside of the chart risks breaking it. Finally please note that the tekton CRDs install resources in specific namespaces.

Installing the helm chart will automatically apply the crds. The tekton crd releases are included in [the crds folder](./crds) and may also be applied manually:
```bash
kubectl apply -f ./crds
```

## Other dependencies
In order to process gitea webhooks Tekton requires [a specialized interceptor](https://github.com/tektoncd/triggers/blob/master/docs/eventlisteners.md#interceptors). We built a [gitea interceptor for tekton triggers](https://github.com/keyporttech/gitea-tekton-interceptor/graphs/traffic). k8sci uses the image built from this project.

## Contributing
We welcome contributions to k8sci nad especially apprciate pull requests that enable other git sources. Please see [keyporttech charts contribution guidelines](https://github.com/keyporttech/helm-charts/blob/master/CONTRIBUTING.md).


## Chart values
| Parameter | Description | Default |
| ----------------------- | --------------------------------------------- | ---------------------------------------------------------- |
| `pullPolicy` | `pull policy for all images` | `ifNotPresent` |
| `imagePullSecrets` | `image pull secrets` | `[]` |
| `nameOverRide` | `Chart name override` | `` |
| `fullNameOverRide` | `helm temnplate name override` | `` |
| `gitSources.gitea` | `create gitea webhook endpoints?` | false |
| `gitSources.github` | `create github webhook endpoints?` | true |
| `cleaner.schedule` | `cron schedule job cleaner runs` | `12 * * * *` |
| `cleaner.maxJobsToKeep` | | `# runs to keep when deleting` | `200` |
| `cicdPipelines` | `list of pipelines - see [pipeline docs](./PIPELINES.md)` | `[]` |
| `notifications.slackWebhook` | `if set sends notifications to slack` | `unset` |
| `pipelineEnvSecrets` | `name/value list stored as k8s secrets and set as ENV values in pipeline run` | `[]` |
| `webhookSecretToken` | `secret token in webhook payload as security validation` | `token_used_by_gihub/gitea` |
| `gitAuthSsh.hosts` | `ssh host list used by tekton generated secret` | `unset` |
| `gitAuth.sshPrivateKey` | `private ssh key text` | `unset` |
| `gitAuth.known_hosts` | `ssh known_hosts file content` | `unset` |
| `securityContext` | `not implemented` |  `{}` |
| `ingress.annotations | 'annotations for all ingresses' {}
| `ingress.host` | 'host name for hook ingresses' | 'chart-example.local` |
| ingress.dashboardHost' | 'host names for dashboard host' | `dashboard.chart-example.local` |
| `ingress.dashboardURL` | `used for generating links to the dashboard` | `https://dashboard.chart-example.local:<PORT>` |
| ingress.tls | 'tls setting for hook ingresses' | `unset` |
| `ingress.dashboardTLS` | `tls for dashboard ingress` | `unset` |
| 'taskResources' | `not implemented` |  `{}` |
