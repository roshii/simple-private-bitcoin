FROM python:alpine AS build-base
WORKDIR /src
RUN apk add \
  autoconf \
  automake \
  build-base \
  git \
  libtool

FROM build-base AS libsecp256k1
RUN apk add linux-headers

RUN git clone --depth 1 https://github.com/bitcoin-core/secp256k1 .
RUN ./autogen.sh \
  && ./configure \
  --disable-benchmark \
  --disable-tests \
  --prefix=/srv \
  && make -j $(nproc) \
  && make install

FROM build-base AS builder
RUN apk add libffi-dev openssl-dev

ARG VERSION_TAG=v0.9.8
RUN git clone --depth 1 --branch ${VERSION_TAG} \
  https://github.com/JoinMarket-Org/joinmarket-clientserver.git .
RUN pip wheel --no-cache --no-deps -w /srv \
  -r requirements/base.txt \
  cryptography==3.3.2

FROM python:alpine AS final
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

COPY --from=libsecp256k1 /srv /usr/local
COPY --from=builder /srv /tmp/pip
COPY --from=builder /src/scripts /opt/jm

RUN apk add \
  libsodium \
  openssl \
  && rm -rf /var/cache/apk/* \
  && pip install --no-cache /tmp/pip/*

WORKDIR /opt/jm

USER satoshi:nakamoto

COPY ./joinmarket-entrypoint.sh /
ENTRYPOINT [ "/joinmarket-entrypoint.sh" ]