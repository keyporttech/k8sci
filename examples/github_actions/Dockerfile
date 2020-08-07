FROM alpine:3.11

RUN apk update && apk add --no-cache bash=5.0.11-r1 curl=7.67.0-r0 git=2.24.3-r0

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

# Install nektos/act
RUN curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash\
