# k8sci configuration

## Chart values| Parameter | Description | Default |
| ----------------------- | --------------------------------------------- | ---------------------------------------------------------- |
| `pullPolicy` | `pull policy for all images` | `ifNotPresent` |
| `imagePullSecrets` | image pull secrets | []` |

gitSources:
  gitea:
    apiEndPoint: https://<GITEA_SERVER>/api/v1
  github:
    apiEndPoint: https://api.github.com

# Job cleaner - prunes old jobs over a certain age
cleaner:
  schedule: 12 * * * *
  maxJobsToKeep: 200

# The cicd pipelines
# each pipeline has a ci task run on push/pull request events
# and a cd command run on merge protected branch (currently only master supported).
# The defined image is used to run the command
# example:
# cicdPipelines:
#   - name: nodejs
#     image: registry.domain.com/node:12.13.0
#     ciCommands:
#       - "make build"
#     cdCommands:
#       - "make deploy"
#   - name: golang
#     image: registry.domain.com:golang:1.14.2-alpine
#     ciCommand: "make build"
#     cdCommand: "make deploy"

# Send notifications for pipeline result
# slackWebhook posts to slack
notifications:
  slackWebhook: https://hooks.slack.com/services/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

# secret that stores env variables set in all pipelines
pipelineEnvSecrets:
  - name: GITHUB_USER
    value: octocat
  - name: GITHUB_TOKEN
    value: token
  - name: GITEA_USER
    value: gitea
  - name: GITEA_TOKEN
    value: token

# secret token use to encrypt payloads but github/gitea
webhookSecretToken: "token_used_by_gihub/gitea"

# gitAuthSsh:
#   hosts:
#    - <YOUR_HOST1>
#   sshPrivatekey: your_key
#   known_hosts: known_hosts_entry_to_your_ssh_server

# gitAuthBasic:
#   hosts:
#    - <YOUR_HOST1>
#   user: <YOUR_USER>
#   password: your_password

gitea:
  apiServer: https://git.keyporttech.com:30243/api


nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000


ingress:
  enabled: false
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  host: chart-example.local
  dashboardHost: dashboard.chart-example.local
  # used for generating links to the dashboard
  dashboardURL: 'https://dashboard.chart-example.local:<PORT>'
  # tls:
  #   - secretName: chart-example-tls
  #     hosts:
  #       - ccicd.example.com
  # dashBoardTLS:
  #   - secretName: dashboard-chart-example-tls
  #     hosts:
  #       - dashboard.cicd.example.com

task-resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi
