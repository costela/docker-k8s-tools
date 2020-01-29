FROM ubuntu:19.10

ARG KUBECTL_VERSION=v1.17.2
ARG HELM_VERSION=v3.0.3
ARG GOMPLATE_VERSION=v3.5.0

ENV COMMON_WGET_OPTIONS "--quiet --show-progress --progress=bar:force --retry-connrefused --retry-on-http-error --retry-on-host-error"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl wget \
    gettext-base \
    awscli \
    jq \
    openssh-client \
    vim \
    ansible \
    unzip \
    git \
    bash-completion \
    && useradd -m app

RUN wget -c -O /usr/local/bin/kubectl ${COMMON_WGET_OPTIONS} \
         https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
         && chmod a+x /usr/local/bin/kubectl

RUN wget -c -O - ${COMMON_WGET_OPTIONS}} https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
         | tar -C /usr/local/bin -xz --strip-components=1

# use "until" to workaround broken retries; github redirects to an authenticated S3 bucket, but when we retry, the auth is stale 
RUN until wget -c -O /usr/local/bin/gomplate ${COMMON_WGET_OPTIONS} \
        https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim; do sleep 1; done \
        && chmod +x /usr/local/bin/gomplate

WORKDIR /home/app
USER app
