ARG image_tag=3.15
FROM python:3.10-alpine${image_tag} AS build-base
WORKDIR /var/tmp
RUN apk add \
  autoconf \
  automake \
  build-base \
  capnproto-dev \
  git \
  libtool

FROM build-base AS libmultiprocess
RUN apk add cmake

RUN git clone --depth 1 \
  https://github.com/chaincodelabs/libmultiprocess.git .
RUN mkdir build \
  && cd build \
  && cmake .. \
  && make -j $(nproc) \
  && make DESTDIR=/srv install

FROM build-base AS builder
COPY --from=libmultiprocess /srv /
RUN apk add \
  boost-dev \
  libevent-dev \
  pkgconfig \
  sqlite-dev \
  zeromq-dev

ARG bitcoin_version_tag=v22.0
RUN git clone --depth 1 --branch ${bitcoin_version_tag} \
  https://github.com/bitcoin/bitcoin.git .
RUN ./autogen.sh \
  && ./configure \
  --prefix=/srv \
  --enable-multiprocess \
  --without-bdb \
  --disable-tests \
  --disable-fuzz-binary \
  --disable-bench \
  && make -j $(nproc) \
  && make install

FROM alpine:${image_tag}
COPY --from=builder /srv /usr
RUN apk add \
  boost1.77-filesystem \
  capnproto \
  libevent \
  sqlite-dev \
  zeromq \
  && mkdir \
  /var/lib/bitcoin \
  /srv/blocks \
  /srv/data \
  /srv/wallet

COPY bitcoin.conf /srv/data/bitcoin.conf
ENTRYPOINT ["bitcoin-node"]
