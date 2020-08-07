# Example pipeline that runs github actions

There are scenarios where it may be desirable to run github actions pipelines outside of github. For example pushign a github repo into gitea or if you want to save money but running load outside of github. The [nektos/act](https://github.com/nektos/act) is design to tun github actions locally. In this example we package this into a docker image that can run on k8sci.

Note this uses the default runner image that comes with act. For complex runner images it may be easier to define a pipline directly in k8s ci.

## build the docker images

## pipeline definition

```yaml
cicdPipelines:
  - name: github-actions
    image: registry.keyporttech.com:30243/github-actions:0.1.0
    ciCommands:
      - execute: "act"
        setStatus: "github-actions"
    cdCommands:
      - execute: "act"
        setStatus: "github-actions"

```
