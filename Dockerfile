ARG VERSION=3.8.0

FROM debian:buster as builder
ARG VERSION

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
        wget \
        git \
        ca-certificates \
        build-essential \
        debhelper \
        devscripts \
        tcl8.6-dev \
        autoconf \
        python3-dev \
        python3-venv \
        dh-systemd \
        libz-dev \
        libboost-system-dev \
        libboost-program-options-dev \
        libboost-regex-dev \
        libboost-filesystem-dev

RUN cd /usr/src && \
    git clone https://github.com/flightaware/piaware_builder.git --branch v${VERSION} && \
    ./piaware_builder/sensible-build.sh buster && \
    cd piaware_builder/package-buster/ && \
    dpkg-buildpackage -b

RUN ls -l /usr/src/piaware_builder

FROM debian:buster
ARG VERSION
COPY --from=builder /usr/src/piaware_builder/piaware_${VERSION}_amd64.deb /tmp/

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
        net-tools \
        tclx8.4 \
        tcllib \
        tcl-tls \
        itcl3 \
        libboost-filesystem1.67.0 \
        libboost-program-options1.67.0 \
        libboost-regex1.67.0 \
        libboost-system1.67.0 \
        libexpat1 \
        libreadline7 && \
    dpkg -i /tmp/piaware_${VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
