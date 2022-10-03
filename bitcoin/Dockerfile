FROM alpine AS build-base
WORKDIR /src
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

ARG VERSION_TAG=v23.0
RUN git clone --depth 1 --branch ${VERSION_TAG} \
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
  && make install \
  && rm /srv/bin/bitcoind

FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

COPY --from=builder /srv /usr
RUN apk add \
  boost1.78-filesystem \
  capnproto \
  libevent \
  sqlite-dev \
  zeromq

RUN install -o satoshi -g nakamoto -d /blocks \
  && install -o satoshi -g nakamoto -d /var/lib/bitcoin

HEALTHCHECK --start-period=20s --interval=10s --timeout=5s \
  CMD run bitcoin-cli -getinfo

USER satoshi:nakamoto
CMD ["bitcoin-node"]
