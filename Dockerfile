FROM ubuntu:18.10

ARG KUBECTL_VERSION=v1.12.3
ARG KOPS_VERSION=1.10.0
ARG KOMPOSE_VERSION=v1.16.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gettext-base \
    awscli \
    jq \
    openssh-client \
    vim \
    ansible \
    unzip \
    && useradd -m app

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod a+x /usr/local/bin/kubectl

RUN curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 -o /usr/local/bin/kops && chmod +x /usr/local/bin/kops

RUN curl -L https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64 -o /usr/local/bin/kompose && chmod +x /usr/local/bin/kompose

WORKDIR /home/app
USER app
