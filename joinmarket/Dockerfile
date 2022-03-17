ARG image_tag=3.15
FROM alpine:${image_tag} AS libs

RUN apk add build-base autoconf automake libtool git
WORKDIR /var/tmp/secp256k1
RUN git clone --depth 1 https://github.com/bitcoin-core/secp256k1 .
RUN ./autogen.sh \
  && ./configure \
  --disable-benchmark \
  --prefix=/srv \
  && make -j $(nproc) \
  && make check \
  && make install

ARG libffi_version_tag=v3.4.2
WORKDIR /var/tmp/libffi
RUN git clone --depth 1 --branch ${libffi_version_tag} \
  https://github.com/libffi/libffi .

RUN apk add linux-headers
RUN ./autogen.sh \
  && ./configure \
  --disable-docs \
  --enable-shared \
  --prefix=/srv \
  && make -j $(nproc) \
  && make check \
  && make install

ARG libsodium_version_tag=1.0.18
WORKDIR /var/tmp/libsodium
RUN git clone --depth 1 --branch ${libsodium_version_tag} \
  https://github.com/jedisct1/libsodium .

RUN ./autogen.sh \
  && ./configure \
  --prefix=/srv \
  && make -j $(nproc) \
  && make check \
  && make install

FROM python:3.10-alpine${image_tag}

ARG joinmarket_version_tag=v0.9.5

WORKDIR /var/tmp
RUN apk add git
RUN git clone --depth 1 --branch ${joinmarket_version_tag} \
  https://github.com/JoinMarket-Org/joinmarket-clientserver.git .

COPY --from=libs /srv /usr
RUN apk add build-base
RUN apk add openssl3-dev
RUN pip install -U pip setuptools virtualenv \
  && virtualenv /opt \
  && source /opt/bin/activate \
  && pip install -r requirements/base.txt
