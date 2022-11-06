FROM python:3.10-alpine AS build-base
RUN apk add \
    build-base \
    git \
  && rm -rf /var/cache/apk/*

WORKDIR /src

FROM build-base AS libsecp256k1
RUN git clone --depth 1 https://github.com/bitcoin-core/secp256k1 . \
  && apk add \
    autoconf \
    automake \
    build-base \
    libtool \
    linux-headers \
  && rm -rf /var/cache/apk/* \
  && ./autogen.sh \
  && ./configure \
    --disable-benchmark \
    --disable-tests \
    --prefix=/srv \
  && make -j $(nproc) \
  && make install

FROM build-base AS builder

ARG VERSION_TAG=master
RUN git clone --depth 1 --branch ${VERSION_TAG} \
  https://github.com/JoinMarket-Org/joinmarket-clientserver.git . \
  && apk add \
    libffi-dev \
    openssl-dev \
  && pip wheel --no-cache --no-deps -w /srv \
  -r requirements/base.txt \
  cryptography==3.3.2

FROM python:3.10-alpine AS final
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