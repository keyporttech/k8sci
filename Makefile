# Copyright 2020 Keyporttech Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

init:
	mkdir -p .keyporttech && curl -o .keyporttech/Makefile.keyporttech https://raw.githubusercontent.com/keyporttech/helm-charts/master/Makefile.keyporttech
.PHONY: init

include ./.keyporttech/Makefile.keyporttech

REGISTRY=registry.keyporttech.com
DOCKERHUB_REGISTRY="keyporttech"
CHART=k8sci
VERSION = $(shell yq r Chart.yaml 'version')
RELEASED_VERSION = $(shell helm repo add keyporttech https://keyporttech.github.io/helm-charts/ > /dev/null && helm repo update> /dev/null && helm show chart keyporttech/$(CHART) | yq - read 'version')
REGISTRY_TAG=${REGISTRY}/${CHART}:${VERSION}
CWD = $(shell pwd)

# Upstream and downstream repos
UPSTREAM_REPO=git@github.com:keyporttech/k8sci.git
DOWNSTREAM_REPO=git@ssh.git.keyporttech.com:keyporttech/k8sCI.git

# PIN to TEKTON versions
TEKTON_PIPELINE_VERSION=v0.18.1
TEKTON_TRIGGERS_VERISON=v0.9.1
TEKTON_DASHBOARD_VERSION=v0.11.1

# Downloads the versioned tekton-releases and puts them in the crds folder
download-tekton:
	rm -f crds/*
	curl -o crds/1_tekton-pipeline-$(TEKTON_PIPELINE_VERSION).yaml https://storage.googleapis.com/tekton-releases/pipeline/previous/$(TEKTON_PIPELINE_VERSION)/release.yaml
	curl -o crds/2_tekton-triggers-$(TEKTON_TRIGGERS_VERISON).yaml https://storage.googleapis.com/tekton-releases/triggers/previous/$(TEKTON_TRIGGERS_VERISON)/release.yaml
	curl -o crds/3_tekton-dashboard-$(TEKTON_DASHBOARD_VERSION).yaml https://storage.googleapis.com/tekton-releases/dashboard/previous/$(TEKTON_DASHBOARD_VERSION)/tekton-dashboard-release.yaml
.PHONY: download-tekton

generate-docs:
	@echo "generating documentation..."
	@echo "generating README.md"
	helm-docs --chart-search-root=./ --template-files=./README.md.gotmpl --template-files=./_templates.gotmpl --output-file=./README.md --log-level=trace
	sed -i 's/pipelineVer/$(TEKTON_PIPELINE_VERSION)/g' ./README.md
	sed -i 's/triggerVer/$(TEKTON_TRIGGERS_VERISON)/g' ./README.md
	sed -i 's/dashboardVer/$(TEKTON_DASHBOARD_VERSION)/g' ./README.md
.PHONY: generate-docs
