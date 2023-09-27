FROM golang:1.19.7-alpine3.16 AS build-env

# TARGETPLATFORM should be one of linux/amd64 or linux/arm64.
ARG TARGETPLATFORM

# Use muslc for static libs
ARG BUILD_TAGS="muslc"
ARG VERSION=master
ARG ORACLE_VERSION=v0.6.2
ARG LD_FLAGS=-linkmode=external \
-extldflags '-Wl,-z,muldefs -static'

# Install cli tools for building and final image
RUN apk add --update --no-cache make git bash gcc linux-headers eudev-dev ncurses-dev openssh curl jq
RUN apk add --no-cache musl-dev

# Build Chain Binary
WORKDIR /go/src/github.com/Team-Kujira
RUN git clone https://github.com/Team-Kujira/core.git
WORKDIR /go/src/github.com/Team-Kujira/core
RUN git fetch
RUN git checkout ${VERSION}
WORKDIR /go/src/github.com/Team-Kujira/core

# Install CosmWasm.
RUN set -eux; \
    WASM_VERSION=$(go list -m all | grep github.com/CosmWasm/wasmvm | awk '{print $NF}'); \
    echo ${WASM_VERSION} ;\
    if [ ! -z "${WASM_VERSION}" ]; then \
      wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.$(uname -m).a; \
    fi; \
    go mod download;

# Build Chain Binary
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ] ; then \
      BUILD_TAGS=${BUILD_TAGS} make install ; \
    fi

RUN if [ "${TARGETPLATFORM}" = "linux/arm64" ] ; then \
      BUILD_TAGS=${BUILD_TAGS} make install ; \
    fi

# Build Oracle
WORKDIR /go/src/github.com/Team-Kujira
RUN git clone https://github.com/Team-Kujira/oracle-price-feeder.git
WORKDIR /go/src/github.com/Team-Kujira/oracle-price-feeder
RUN git fetch
RUN git checkout ${ORACLE_VERSION}

RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ] ; then \
      LEDGER_ENABLED=false GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go install -ldflags ${LD_FLAGS} -tags ${BUILD_TAGS} ; \
    fi

RUN if [ "${TARGETPLATFORM}" = "linux/arm64" ] ; then \
      LEDGER_ENABLED=false GOOS=linux GOARCH=arm64 CGO_ENABLED=1 go install -ldflags ${LD_FLAGS} -tags ${BUILD_TAGS} ; \
    fi
RUN echo $(ls -1 /go/bin)

# Use busybox to create a user
FROM busybox:stable-musl AS busybox
RUN addgroup --gid 1137 -S user && adduser --uid 1137 -S user -G user

# Use scratch for the final image
FROM scratch
WORKDIR /bin

# Label should match your github repo
LABEL org.opencontainers.image.source="https://github.com/PFC-Developer/kujirad:${VERSION}"

# Installs all binaries built with go.
COPY --from=build-env /go/bin/kujirad /bin
COPY --from=build-env /go/bin/price-feeder /bin

# Other binaries we want to keep.
COPY --from=build-env /usr/bin/ldd /bin/ldd
COPY --from=build-env /usr/bin/curl /bin/curl
COPY --from=build-env /usr/bin/jq /bin/jq

# Install Libraries
COPY --from=build-env /usr/lib/libgcc_s.so.1 /lib/
COPY --from=build-env /lib/ld-musl*.so.1* /lib

# jq Libraries
COPY --from=build-env /usr/lib/libonig.so.5 /lib

# curl Libraries
COPY --from=build-env /usr/lib/libcurl.so.4 /lib
COPY --from=build-env /lib/libz.so.1 /lib
COPY --from=build-env /usr/lib/libnghttp2.so.14 /lib
COPY --from=build-env /lib/libssl.so.1.1 /lib
COPY --from=build-env /lib/libcrypto.so.1.1 /lib
COPY --from=build-env /usr/lib/libbrotlidec.so.1 /lib
COPY --from=build-env /usr/lib/libbrotlicommon.so.1 /lib

# Install trusted CA certificates for curl
COPY --from=build-env /etc/ssl/cert.pem /etc/ssl/cert.pem
COPY --from=build-env /etc/ssl/cert.pem /etc/ssl/certs/ca-certificates.crt

# Install cli tools from busybox
COPY --from=busybox /bin/ln /bin/ln
COPY --from=busybox /bin/ln /bin/sh

# Link each binary you want to sh to save space.
RUN for binary in \
dd \
vi \
chown \
id \
cp \
mkdir \
ls \
sh \
cat \
less \
grep \
sleep \
env \
tar \
tee \
du \
sort \
head \
df \
nc \
chmod \
touch \
sed \
rm \
netstat \
; do ln sh $binary; done


# Copy user
COPY --from=busybox /etc/passwd /etc/passwd
COPY --from=busybox --chown=1137:1137 /home/user /home/user
COPY price-feed.sh /home/user/price-feed.sh
RUN ["chmod", "+x", "/home/user/price-feed.sh"]
RUN echo $(ls -1 /bin)
# Set home directory and user
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
VOLUME [ "/state","/config" ]
CMD ["/home/user/price-feed.sh"]
