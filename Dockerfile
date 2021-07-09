FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive \
    FLB_VER=1.7.7

RUN apt-get update -yq && \
    apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends \
    bison \
    build-essential \
    ca-certificates \
    cmake \
    flex \
    libsasl2-dev \
    libssl-dev \
    libsystemd-dev \
    libzstd-dev \
    make \
    pkg-config \
    tar \
    wget \
    zlib1g-dev

RUN wget -q -c -nH https://github.com/fluent/fluent-bit/archive/v${FLB_VER}.tar.gz -O /tmp/fluent-bit.tar.gz && \
    mkdir -p /tmp/fluent-bit && \
    tar zxf /tmp/fluent-bit.tar.gz -C /tmp/fluent-bit --strip-components=1 && \
    rm -rf /tmp/fluent-bit.tar.gz /tmp/fluent-bit/build/* && \
    cd /tmp/fluent-bit/build

WORKDIR /tmp/fluent-bit/build
RUN cmake \
    -DFLB_RELEASE=ON \
    -DFLB_JEMALLOC=ON \
    -DFLB_TLS=ON \
    -DFLB_HTTP_SERVER=ON \
    -DFLB_IN_SYSTEMD=ON \
    -DFLB_LUAJIT=ON \
    -DFLB_RECORD_ACCESSOR=ON \
    -DFLB_TRACE=OFF \
    -DFLB_SHARED_LIB=OFF \
    -DFLB_EXAMPLES=OFF \
    ..

RUN make -j $(getconf _NPROCESSORS_ONLN)
RUN install -o root -g root -m 755 bin/fluent-bit /usr/bin/

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    FLB_VER=1.7.7

RUN apt-get update -yq && \
    apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends \
        busybox \
        ca-certificates \
        libgcc-s1 \
        libgcrypt20 \
        libgpg-error0 \
        liblz4-1 \
        liblzma5 \
        libpcre3 \
        libsasl2-2 \
        libssl1.1 \
        libsystemd0 \
        libzstd1 \
        zlib1g && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Time Zone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Install fluentd
COPY --from=builder /usr/bin/fluent-bit /usr/bin/fluent-bit

RUN mkdir -p /etc/fluent-bit
COPY fluent-bit.conf /etc/fluent-bit/fluent-bit.conf

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod 755 /root/entrypoint.sh

# HTTP Server for metrics
EXPOSE 2020

VOLUME /tmp
RUN chmod 1777 /tmp

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["fluent-bit"]

