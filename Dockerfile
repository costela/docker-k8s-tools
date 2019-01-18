FROM ubuntu:18.10

ARG KOPS_VERSION=1.11.0
ARG KUBECTL_VERSION=v1.12.3
ARG KOMPOSE_VERSION=v1.16.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl wget \
    gettext-base \
    awscli \
    jq \
    openssh-client \
    vim \
    ansible \
    unzip \
    bash-completion \
    && useradd -m app

RUN wget -c -O /usr/local/bin/kubectl --quiet --show-progress --progress=bar:force --retry-connrefused --retry-on-http-error --retry-on-host-error \
         https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
         && chmod a+x /usr/local/bin/kubectl

# use "until" to workaround broken retries; github redirects to an authenticated S3 bucket, but when we retry, the auth is stale 
RUN until wget -c -O /usr/local/bin/kops --quiet --show-progress --progress=bar:force --retry-connrefused --retry-on-http-error --retry-on-host-error \
         https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64; do sleep 1; done \
         && chmod +x /usr/local/bin/kops

RUN until wget -c -O /usr/local/bin/kompose --quiet --show-progress --progress=bar:force --retry-connrefused --retry-on-http-error --retry-on-host-error \
         https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64; do sleep 1; done \
         && chmod +x /usr/local/bin/kompose

WORKDIR /home/app
USER app
