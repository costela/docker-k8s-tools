FROM ubuntu:jammy

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    less curl wget \
    gettext-base \
    awscli \
    jq \
    openssh-client \
    vim \
    unzip \
    git \
    bash-completion \
    python3-venv python3-wheel python3-cryptography \
    && useradd -m app \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


ARG KUBECTL_VERSION=v1.22.4
ARG HELM_VERSION=v3.10.2
ARG HELMFILE_VERSION=v0.144.0
ARG GOMPLATE_VERSION=v3.5.0
ARG TERRAFORM_VERSION=1.5.0
ARG PULUMI_VERSION=v3.33.2
ARG GCLOUD_VERSION=373.0.0
ARG STERN_VERSION=1.22.0
ARG FIREBASE_VERSION=v9.10.2

ENV COMMON_WGET_OPTIONS "--quiet --show-progress --progress=bar:force --retry-connrefused --retry-on-http-error --retry-on-host-error"

RUN wget -c -O /usr/local/bin/kubectl ${COMMON_WGET_OPTIONS} \
        https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod a+x /usr/local/bin/kubectl

RUN wget -c -O - ${COMMON_WGET_OPTIONS} https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
        | tar -C /usr/local/bin -xz --strip-components=1

RUN wget -c -O - ${COMMON_WGET_OPTIONS} https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        | funzip  > /usr/local/bin/terraform \
        && chmod a+x /usr/local/bin/terraform

RUN wget -c -O - ${COMMON_WGET_OPTIONS} https://get.pulumi.com/releases/sdk/pulumi-${PULUMI_VERSION}-linux-x64.tar.gz \
        | tar -C /usr/local/bin -xz --strip-components=1

# use "until" to workaround broken retries; github redirects to an authenticated S3 bucket, but when we retry, the auth is stale 
RUN until wget -c -O /usr/local/bin/gomplate ${COMMON_WGET_OPTIONS} \
        https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim; do sleep 1; done \
        && chmod +x /usr/local/bin/gomplate

RUN until wget -c -O /usr/local/bin/helmfile ${COMMON_WGET_OPTIONS} \
        https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64; do sleep 1; done \
        && chmod +x /usr/local/bin/helmfile

RUN until wget -c -O /usr/local/bin/firebase ${COMMON_WGET_OPTIONS} \
        https://github.com/firebase/firebase-tools/releases/download/${FIREBASE_VERSION}/firebase-tools-linux; do sleep 1; done \
        && chmod +x /usr/local/bin/firebase

RUN cd /opt/ && wget -c -O - ${COMMON_WGET_OPTINOS} https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz | tar -xz && ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
ENV CLOUDSDK_PYTHON_SITEPACKAGES=1

RUN wget -c -O - ${COMMON_WGET_OPTIONS} \
        https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_amd64.tar.gz | tar -C /usr/local/bin -xz

WORKDIR /home/app
USER app
