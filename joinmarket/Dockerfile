ARG image_tag=3.15
FROM python:3.10-alpine${image_tag} AS build-base

RUN apk add \
  autoconf \
  automake \
  build-base \
  git \
  libtool \
  linux-headers \
  openssl-dev

WORKDIR /var/tmp

FROM build-base AS libsecp256k1
RUN git clone --depth 1 https://github.com/bitcoin-core/secp256k1 .
RUN ./autogen.sh \
  && ./configure \
  --disable-benchmark \
  --disable-tests \
  --prefix=/srv \
  && make -j $(nproc) \
  && make install

FROM build-base AS libffi
ARG libffi_version_tag=v3.4.2
RUN git clone --depth 1 --branch ${libffi_version_tag} \
  https://github.com/libffi/libffi .

RUN ./autogen.sh \
  && ./configure \
  --disable-docs \
  --disable-tests \
  --enable-shared \
  --prefix=/srv \
  && make -j $(nproc) \
  && make install

FROM build-base AS libsodium
ARG libsodium_version_tag=1.0.18
RUN git clone --depth 1 --branch ${libsodium_version_tag} \
  https://github.com/jedisct1/libsodium .

RUN ./autogen.sh \
  && ./configure \
  --disable-tests \
  --prefix=/srv \
  && make -j $(nproc) \
  && make install

FROM build-base AS builder
ARG joinmarket_version_tag=v0.9.5
RUN git clone --depth 1 --branch ${joinmarket_version_tag} \
  https://github.com/JoinMarket-Org/joinmarket-clientserver.git .

COPY --from=libffi /srv /usr
RUN pip install --no-cache -U pip setuptools \
  && pip wheel --no-cache --no-deps -w /srv \
  -r requirements/base.txt \
  cffi \
  cryptography==3.3.2 \
  future \
  pyaes \
  urldecode \
  zope.interface

FROM python:3.10-alpine${image_tag}
COPY --from=libsodium /srv /usr
COPY --from=libsecp256k1 /srv /usr
COPY --from=builder /srv /opt/joinmarket
RUN pip install --no-cache /opt/joinmarket/*

ARG workdir=/opt/joinmarket
COPY --from=builder /var/tmp/scripts ${workdir}
WORKDIR ${workdir}

ENTRYPOINT ["python"]
