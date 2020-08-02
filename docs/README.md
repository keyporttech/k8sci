# k8sci Documentation

## Contents

[Tekton Dependencies](#tektonDependencies)
[Gitea dependencies](#giteaDependencies)
[Pipelines](./PIPELINES.md)
[Git commit statuses]()
[Pipeline Secrets]()
[git ssh config]()
[Pipeline Examples]()
[Ingress Config and Webhooks](./INGRESS_ENDPOINTS.md)
[Git Sources]()
[Webhook Endpoints]
[Dshboard Ingress]
[Creating a gitub webhook]
[Creating a gitea webhook]

[Chart Values](#chartValues)

## Tekton dependencies<a name="tektonDependencies"></a>
This chart uses the CRDs which are the release files supplied by tekton releases. Since tekton releases often and sometimes with breaking changes we pin a k8sci release to specific versions of tekton pipelines, tekton triggers and tekton dashboard. The specific crds files are included in the crds directory. Please note that deleting this chart will not remove the dependencies since they are not templated. Also changing the version of the CRDs outside of the chart risks breaking it. Finally please note that the tekton CRDs install resources in specific namespaces.

## Gitea dependencies<a name="giteaDependencies"></a>
In order to process Gitea webhooks Tekton requires a specialized interceptor.

## Chart values| Parameter | Description | Default |<a name="chartValues></a>
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
