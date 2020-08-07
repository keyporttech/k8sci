# Example pipeline golang

This is a very simple pipeline is used to run continuous integration on a golang source repo. The continuous integration tasks integration tasks run go build and go test. There is no continuos deployment in this pipeline.

## build the docker images
```bash
cd examples/golang_pipeline
docker build . -t keyporttech/golang-pipeline:0.0.1
```

```yaml
cicdPipelines:
- name: golang
  image: registry.keyporttech.com:30243/golang:1.14.2-alpine
  ciCommands:
    - excute: "go build"
      setStatus: build
    - excute: "go test"
      setStatus: test
```
