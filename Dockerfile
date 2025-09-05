FROM alpine:3.22.1

ARG VCS_REF
ARG BUILD_DATE
ARG TARGETARCH

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/groundnuty/k8s-wait-for" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV KUBE_VERSION="v1.32.8"

# explicit update of libcrypto to avoid CVE-2024-5535 (until base alpine is updated)
RUN apk add --update --no-cache ca-certificates=20250619-r0 curl=8.14.1-r1 
RUN curl -L https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/$TARGETARCH/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Replace for non-root version
ADD wait_for.sh /usr/local/bin/wait_for.sh

ENTRYPOINT ["wait_for.sh"]
