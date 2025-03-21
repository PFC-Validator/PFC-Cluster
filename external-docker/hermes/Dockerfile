#FROM rust:1-buster AS build-env
FROM rust:1-bullseye AS build-env

ARG VERSION=master
ARG PROTOC_VERSION=28.3

WORKDIR /root
# Install protoc
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH=x86_64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        ARCH=aarch_64;\
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-$ARCH.zip -O /tmp/protoc.zip && \
    unzip /tmp/protoc.zip -d /usr/local && \
    rm -rf /tmp/protoc.zip
RUN apt update && apt install -y clang libssl-dev pkg-config

RUN git clone https://github.com/informalsystems/hermes.git
WORKDIR /root/hermes
RUN git fetch
RUN git checkout ${VERSION}
RUN cargo build --release


FROM ubuntu:latest
LABEL maintainer="hello@informal.systems,pfc@pfc.zone"
ARG UID=1001
ARG GID=1001

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget vim curl 
RUN update-ca-certificates
RUN groupadd -g ${GID} hermes && useradd -l -m hermes -s /bin/bash -u ${UID} -g ${GID}

WORKDIR /home/hermes

RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        DEB_URL=http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb; \
    elif [ "$ARCH" = "aarch64" ]; then \
        DEB_URL=http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_arm64.deb; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    wget $DEB_URL -O /tmp/libssl1.1.deb && \
    dpkg -i /tmp/libssl1.1.deb && \
    rm -rf /tmp/libssl1.1.deb

RUN wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN chmod 755 /usr/bin/yq

COPY --chown=hermes:hermes --from=build-env /root/hermes/target/release/hermes /usr/bin/hermes
# Label should match your github repo
LABEL org.opencontainers.image.source="https://github.com/PFC-Validator/PFC-Cluster/external-docker/hermes"
LABEL org.opencontainers.image.description="Hermes Relayer"

WORKDIR /home/hermes
COPY hermes.sh /home/hermes/hermes.sh
COPY hermes_cmd.sh /home/hermes/hermes_cmd.sh
COPY init_keys.sh /home/hermes/init_keys.sh
COPY balances.sh /home/hermes/balances.sh
RUN ["chmod", "+x", "/home/hermes/hermes.sh"]
RUN ["chmod", "+x", "/home/hermes/hermes_cmd.sh"]
RUN ["chmod", "+x", "/home/hermes/init_keys.sh"]
RUN ["chmod", "+x", "/home/hermes/balances.sh"]

RUN mkdir /home/hermes/.hermes
RUN chmod 777 /home/hermes/.hermes
USER hermes:hermes


ENV CONFIGFILE=file://none
EXPOSE 3000
EXPOSE 3001

VOLUME [ "/keys","/config","/init" ]
CMD ["/home/hermes/hermes.sh"]
