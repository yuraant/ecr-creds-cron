FROM alpine:3.10

LABEL maintainer="yura.ant@gmail.com" \
      name="aws-kubectl" \
      description="Image includes: AWS CLI and kubectl for kubernetes jobs and cronjobs" \
      version="0.1.1"

ENV kubectl_version=1.14.7
ENV awscli_version=1.17.8
ENV s3cmd_version=2.0.2

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        openssl \
        && \
    pip install --upgrade awscli==${awscli_version} s3cmd==${s3cmd_version} python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*


RUN wget -q -O kubectl https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin


WORKDIR /tmp