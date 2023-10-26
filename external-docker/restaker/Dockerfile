FROM node:18-slim

# TARGETPLATFORM should be one of linux/amd64 or linux/arm64.
ARG TARGETPLATFORM

ARG GIT_VERSION=v2.11.0

# Install cli tools for building and final image
RUN apt-get update
RUN apt-get install -y make git bash gcc  ncurses-dev curl jq python3 g++

# Build Chain Binary
WORKDIR /
RUN git clone https://github.com/pfc-developer/restake.git
#RUN git clone https://github.com/eco-stake/restake.git

WORKDIR /restake
RUN git fetch
RUN git checkout ${GIT_VERSION}
RUN npm install

RUN mkdir /config
ENV DIRECTORY_PROTOCOL=https
ENV DIRECTORY_DOMAIN=cosmos.directory

ENV MNEMONIC=NONE
ENV ONLY_OPERATORS=true
ENV NETWORKS_OVERRIDE_PATH=/config

VOLUME [ "/config" ]
CMD npm run autostake
