# syntax=docker/dockerfile:1.4
FROM ubuntu:focal AS build-env

RUN <<EOF
    apt-get update
    apt-get install -y \
        build-essential \
        make \
        gcc-9 \
        libssl-dev \
        wget \
        tar \
        gosu
    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
    groupadd -o -g 1000 user
    useradd -o -m -u 1000 -g user user
EOF

ARG RELEASE_URL=https://github.com/jedisct1/pure-ftpd/releases/download/1.0.50/pure-ftpd-1.0.50.tar.gz
RUN <<EOF
    mkdir -p /work
    chown -R "user:user" /work
    cd /work

    gosu user wget -O "pure-ftpd.tar.gz" "${RELEASE_URL}"
    gosu user tar xf "pure-ftpd.tar.gz"
EOF

RUN <<EOF
    cd /work
    cd pure-ftpd-*

    mkdir -p /install
    chown -R "user:user" /install

    gosu user ./configure --prefix=/install --with-altlog --with-tls --with-puredb
    gosu user make install-strip
EOF


FROM ubuntu:focal AS runtime-env

RUN <<EOF
    apt-get update
    apt-get install -y \
        openssl \
        gosu
    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
    groupadd -o -g 1000 ftpuser
    groupadd -o -g 2000 ftpgroup
    useradd -o -m -u 1000 -g ftpuser -G ftpgroup ftpuser
EOF

COPY --from=build-env /install/ /usr/local/

ENTRYPOINT [ "gosu", "ftpuser", "/usr/local/sbin/pure-ftpd" ]
