FROM golang:1.21-alpine3.18 AS oracle
RUN apk add --no-cache git make gcc libc-dev
WORKDIR /go/src/github.com/team-kujira
RUN git clone https://github.com/Team-Kujira/oracle-price-feeder.git
WORKDIR /go/src/github.com/team-kujira/oracle-price-feeder
RUN set -eux; \
    WASM_VERSION=$(go list -m all | grep github.com/CosmWasm/wasmvm | awk '{print $NF}'); \
    echo ${WASM_VERSION} ;\
    if [ ! -z "${WASM_VERSION}" ]; then \
      wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.$(uname -m).a; \
    fi; \
    go mod download;


#RUN wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/v1.0.0/libwasmvm_muslc.x86_64.a
ARG ORACLE_VERSION=master
RUN git checkout ${ORACLE_VERSION}
RUN COMMIT="$(git rev-parse HEAD)"; BUILD_TAGS=muslc CGO_ENABLED=1 go install -mod=readonly -tags "muslc" -ldflags "-X price-feeder/cmd.Version=${ORACLE_VERSION}-$COMMIT -X price-feeder/cmd.Commit=$COMMIT" ./...

#FROM golang:alpine AS core
FROM golang:1.21-alpine3.18 AS core
RUN apk add --no-cache git make gcc libc-dev
WORKDIR /go/src/github.com/team-kujira
RUN git clone https://github.com/Team-Kujira/core.git
WORKDIR /go/src/github.com/team-kujira/core
#RUN wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/v1.0.0/libwasmvm_muslc.x86_64.a
RUN set -eux; \
    WASM_VERSION=$(go list -m all | grep github.com/CosmWasm/wasmvm | awk '{print $NF}'); \
    echo ${WASM_VERSION} ;\
    if [ ! -z "${WASM_VERSION}" ]; then \
      wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.$(uname -m).a; \
    fi; \
    go mod download;


ARG VERSION=master
RUN git checkout ${VERSION}
RUN COMMIT="$(git rev-parse HEAD)"; BUILD_TAGS=muslc CGO_ENABLED=1 go install -mod=readonly -tags "muslc" -ldflags "-X price-feeder/cmd.Version=${VERSION}-$COMMIT -X price-feeder/cmd.Commit=$COMMIT" ./...

#FROM alpine:latest 
FROM alpine:3.18
COPY --from=oracle /go/bin/price-feeder /usr/local/bin
COPY --from=core /go/bin/kujirad /usr/local/bin
RUN apk add --no-cache gcc curl jq openssh
RUN addgroup --gid 1137 -S user && adduser --uid 1137 -S user -G user

COPY price-feed.sh /home/user/price-feed.sh
RUN ["chmod", "+x", "/home/user/price-feed.sh"]
WORKDIR /home/user
RUN mkdir /state
RUN chmod 777 /state
RUN touch /state/.empty
RUN chown -R user /home/user
USER user
ENV SEEDPHRASE=NONE
ENV APISERVER=NONE
ENV RPCSERVER=NONE
ENV GRPCSERVER=NONE
ENV ADDRESS=kuji...
ENV VALIDATOR=kujivaloper...
ENV CONFIGFILE=file://none
EXPOSE 8171

VOLUME [ "/state","/config" ]
CMD ["/home/user/price-feed.sh"]
#ENTRYPOINT ["/usr/local/bin/price-feeder"]
