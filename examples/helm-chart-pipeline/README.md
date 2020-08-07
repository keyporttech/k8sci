# Example helm chart pipeline with a Makefile

This pipeline is used to lint any helm chart. For convenience and flexibility we use a Makefile to define the functions. This pipeline is used in keyporttech's pipelines. The Makefile used is included in this example.

```yaml
cicdPipelines:
  - name: helm-cicd-pipeline
    image: registry.keyporttech.com:30243/chart-testing:0.1.5
    ciCommands:
      - execute: "make check-version"
        setStatus: "version-check"
      - execute: "make lint"
        setStatus: "lint"
      - execute: "make test"
        setStatus: "test"
    cdCommands:
      - execute: "make deploy"
      - setStatus: "deployed"
```
