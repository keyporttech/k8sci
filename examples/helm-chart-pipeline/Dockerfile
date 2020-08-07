FROM quay.io/helmpack/chart-testing:v3.0.0-rc.1

# install docker
RUN apk update && apk add --no-cache docker=19.03.5-r1 openrc=0.42.1-r2 openssh-client=8.1_p1-r0 && \
    rc-update add docker boot

# install yq
# hadolint ignore=SC2094
RUN curl -LO https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 && \
    chmod +x yq_linux_amd64 && \
    mv yq_linux_amd64 /usr/local/bin/yq && \
    apk --no-cache add make=4.2.1-r2 bash=5.0.11-r1

# install hadolint
# hadolint ignore=SC2094
RUN curl -fsSL -o hadolint https://github.com/hadolint/hadolint/releases/download/v1.18.0/hadolint-Linux-x86_64 && \
  chmod +x hadolint && \
  mv hadolint /usr/local/bin

# install helmfile
RUN curl -fsSL -o helmfile https://github.com/roboll/helmfile/releases/download/v0.118.7/helmfile_linux_amd64 && \
  chmod +x helmfile && \
  mv helmfile /usr/local/bin

RUN curl -fsSL -o cr.tar.gz https://github.com/helm/chart-releaser/releases/download/v1.0.0-beta.1/chart-releaser_1.0.0-beta.1_linux_amd64.tar.gz && \
  tar xzf cr.tar.gz  && \
  chmod +x cr && \
  mv cr /usr/local/bin
