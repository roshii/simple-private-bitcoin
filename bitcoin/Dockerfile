ARG image_tag=3.15
FROM alpine:${image_tag} AS libmultiprocess

WORKDIR /var/tmp
RUN apk add git
RUN git clone --depth 1 https://github.com/chaincodelabs/libmultiprocess.git .

RUN apk add build-base cmake
RUN apk add capnproto-dev
RUN mkdir build \
  && cd build \
  && cmake .. \
  && make -j $(nproc) \
  && make DESTDIR=/srv install

FROM alpine:${image_tag} AS builder

ARG bitcoin_version_tag=v22.0

WORKDIR /var/tmp
RUN apk add git
RUN git clone --depth 1 --branch ${bitcoin_version_tag} \
  https://github.com/bitcoin/bitcoin.git .

RUN apk add autoconf automake libtool pkgconfig
RUN ./autogen.sh

RUN apk add build-base boost-dev libevent-dev
RUN apk add capnproto-dev sqlite-dev zeromq-dev
COPY --from=libmultiprocess /srv /

RUN ./configure \
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
