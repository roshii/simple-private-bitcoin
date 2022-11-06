FROM golang:alpine AS builder
RUN apk add \
  build-base \
  git

WORKDIR /src

ARG VERSION_TAG="master"
RUN git clone --depth 1 --branch ${VERSION_TAG} \
  https://github.com/lightningnetwork/lnd . \
  && make release-install

FROM alpine AS final
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

COPY --from=builder /go/bin/ /bin/

HEALTHCHECK --start-period=120s --interval=60s --timeout=10s \
  CMD lncli getinfo

USER satoshi:nakamoto
CMD ["lnd"]