FROM golang:1.14.2-alpine

ENV K8S_VERSION=1.18.1

# standard dev tools
# hadolint ignore=DL3018
RUN apk add --no-cache openssh jq curl wget bash openssl make g++
# required so that pipes work properly in the Dockerfile
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

# Get the kubectl binary.
# hadolint ignore=SC2094
# hadolint ignore=SC2094
RUN curl -LO  https://dl.k8s.io/v${K8S_VERSION}/kubernetes-client-linux-amd64.tar.gz && \
    tar xzf kubernetes-client-linux-amd64.tar.gz && \
    mv ./kubernetes/client/bin/kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    rm -rf kubernetes kubernetes-client-linux-amd64.tar.gz

# install helm
# hadolint ignore=SC2094
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm -f get_helm.sh
