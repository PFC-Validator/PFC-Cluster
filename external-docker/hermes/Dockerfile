FROM rust:1-buster AS build-env

ARG VERSION=master
WORKDIR /root
RUN git clone https://github.com/informalsystems/hermes.git
WORKDIR /root/hermes
RUN git fetch
RUN git checkout ${VERSION}
RUN cargo build --release


FROM ubuntu:latest
LABEL maintainer="hello@informal.systems"
ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget
RUN update-ca-certificates
RUN groupadd -g ${GID} hermes && useradd -l -m hermes -s /bin/bash -u ${UID} -g ${GID}

WORKDIR /home/hermes
RUN wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN chmod 755 /usr/bin/yq

COPY --chown=hermes:hermes --from=build-env /root/hermes/target/release/hermes /usr/bin/hermes
# Label should match your github repo
LABEL org.opencontainers.image.source="https://github.com/PFC-Validator/PFC-Cluster/external-docker/hermes"
LABEL org.opencontainers.image.description="Hermes Relayer"

WORKDIR /home/hermes
COPY hermes.sh /home/hermes/hermes.sh
COPY init_keys.sh /home/hermes/init_keys.sh
COPY balances.sh /home/hermes/balances.sh
RUN ["chmod", "+x", "/home/hermes/hermes.sh"]
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
