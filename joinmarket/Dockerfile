ARG image_tag=3.15
FROM python:3.10-alpine${image_tag} AS build-base
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

ARG joinmarket_version_tag=v0.9.5
RUN git clone --depth 1 --branch ${joinmarket_version_tag} \
  https://github.com/JoinMarket-Org/joinmarket-clientserver.git .
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
COPY --from=libsecp256k1 /srv /usr
COPY --from=builder /srv /tmp/pip
RUN apk add libsodium \
  && pip install --no-cache /tmp/pip/*

WORKDIR /opt/jm
COPY --from=builder /src/scripts /opt/jm
COPY joinmarket.cfg /srv/joinmarket.cfg

ENTRYPOINT ["python"]
