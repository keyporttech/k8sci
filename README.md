# k8sCI

This is the CI/CD system we use at keyporttech. It is an implementation of (tekton/pipeline)[https://github.com/tektoncd/pipeline] (tekton/trigger)[https://github.com/tektoncd/triggers] packaged into a helm chart.

(Tekton pipelines)[https://github.com/tektoncd/pipeline] are kubernetes custom resource definitions designed specifically for running jobs and pipelines. Tecton pipelines are used to create a pipeline that runs make using a Makefile. By default the pipeline will execute make build targets on code pushes, and make deploy on merge to master. To use k8sCI you need to: install tecton pipeline, triggers, dashboard, install the k8sCI helm chart with the build image configured in the yaml, add web hooks to your source repo. k8sCI has been tested with both public github and gitea running on kuberenets 1.18 on a bare-metal cluster.

There is no centralized server, no Jenkinsfiles or other yaml config needed. After the initial setup you add webhooks and Makefile if not present. Build images for build containers must be supplied by the end user, but the keyportech golang and nodejs images are provided as examples.

Don't like Makefiles or need more specialized pipelines? Not a problem k8sCI is easy to modify and provides an excellent starting point for you own custom platform.

## Installation

### prerequisites

1.) A running modern supported version of kubernetes with client tools installed.

2.) Tecton CRDs installed on the cluster. The tecton CRDs are deliberately left out of the helm chart, since they have their own install ditribtions and are evolving rapidly.

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

### configuration and usage

In order to use k8sCI you must pro
