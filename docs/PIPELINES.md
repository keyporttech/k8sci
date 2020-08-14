# Defining Pipelines

K8sci pipeline definition syntax focuses on the essentials. It defines an image, a list of commands to run during CI (Pull_request and push events) and CD events ( pushes to master or PR merges). An optional commit status name may set to notify the git provider for each command.

This minimalist approach is flexible and leaves it to the end user to define their pipeline architecture. Users may include additional pipeline metadata with their code repository similar to a Jenkinsfile or they can create an immutable pipeline baked into their image. Immutable pipelines are useful for increased security as an example for dependent upstream code. Maintainers may define metadata in a source code repo in many different ways. It is even possible to use pipeline definitions from other CICD providers such as github actions.

Most of the examples provided use Makefile because it is simple, powerful, and widely understood.

## Pipeline anatomy
```yaml
cicdPipelines:
- name: my awesome pipeline
  image: <IMAGE_NAME>:<VERSION>
  ciCommands:
    - execute: "command 1"
      setStatus: "command-1"
    - execute: "command 2"
      setStatus: "command-2"
    - execute: "command 3"
      setStatus: "command-3"
  cdCommands:
    - execute: "deploy it"
    - setStatus: "deployed"
```
* name - name of the pipeline
* image - docker image and tag that the commands run in. At a minimum the image should have bash installed since bash is used to execute commands.
* ciCommands - List of commands to run on continuous integration events. These are defined as PULL_REQUEST and PUSH events in both gitea and github.
  * execute - the command to run. Commands are run in the order the are listed inside a bash shell in the supplied image.
  * setStatus - Optional field that will set a commit status of the supplied value for the event's sha. Set's status to pending then either success or failure depending on the output of the command.
* cdCommands - List of commands to run on continuous deployment. These commands are triggered when merges and when changes are pushed to the master branch. 'master' is the only protected branch supported at this time.
  * execute - same as above for ciCommands
    setStatus - same as above for ciCommands

## Git Commit Statuses
If the setStatus value is set in a pipeline:
  * A status of "pending" with the set value sent be set by the pipeline before it runs.
  * After running a status of "success" with be set if the xit code is zero or "failure" otherwise.
  * If not setStatus name is specified then no status is set.
  * This process applies to each command in a pipeline so multiple statuses may be set.
  * This process works the same for both gitea and github

## Secrets
Any secret value needed by you pipeline should be defined in pipelineEnvSecrets. Both GITEA_TOKEN and GITHUB_TOKEN are needed to set commit statuses described above.

```yaml
pipelineEnvSecrets:
  - name: GITHUB_USER
    value: octocat
  - name: GITHUB_TOKEN
    value: token
  - name: GITEA_USER
    value: gitea
  - name: GITEA_TOKEN
    value: token
```

## ssh config
Tekton requires an ssh key and known host secrets to be created for each repo. These both should be defined in your values.yaml file. The value sshPrivateKey is the private key valued and added to either or both your gitea or github servers. K8sCI currently only supports a single ssh key that is shared across multiple servers. The value known_hosts is set in the running containers ~/.ssh directory to avoid host if validation. If this is not set properly the pipeline will hang indefinitely as it waits for the key to be validated. The known_hosts
The value hosts is used by tekton to map a host name to a key. Be sure to list out all hosts including multiple gitea instances and github as needed.
```yaml
gitAuthSsh:
  hosts:
    - "gitea_host_dns_or_ip:<PORT>"
    - "github.com"
  sshPrivatekey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    AAAAAAAAAAAAAAAAAA....
    -----END OPENSSH PRIVATE KEY-----

  known_hosts: |-
    [gitea_host_dns_or_ip]:<PORT>,[##.##.##.##]:<PORT22 ecdsa-sha2-nistp256 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA...=
    [github.com]:<PORT>,[##.##.##.##]:<PORT22 ecdsa-sha2-nistp256 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA...=
```

## Enabling Slack notifications

If configured k8sci can send notifications using a (slack webhook)[https://api.slack.com/messaging/webhooks]. This can be configured as follows in your values.yaml:

```yaml
slack-notify:
  slack-webhook: "https://hooks.slack.com/services/TTTTTTTTT/B011111111111111111111111111111111"
```
