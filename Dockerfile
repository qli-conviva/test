FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    EXPORTER_VER=1.1.2

RUN apt-get update -yq && \
    apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends --auto-remove \
        busybox \
        ca-certificates \
        gzip && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/prometheus /tmp/node_exporter && \
    busybox wget -q -c -O /tmp/node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v${EXPORTER_VER}/node_exporter-${EXPORTER_VER}.linux-amd64.tar.gz && \
    tar zxf /tmp/node_exporter.tar.gz -C /tmp/node_exporter --strip-components=1 && \
    mv /tmp/node_exporter/node_exporter /usr/bin && \
    chmod 755 /usr/bin/node_exporter && \
    rm -rf /tmp/node_exporter*

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod 755 /root/entrypoint.sh

EXPOSE 9100

VOLUME /tmp
RUN chmod 1777 /tmp

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["node_exporter"]
