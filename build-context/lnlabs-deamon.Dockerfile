FROM golang:alpine AS builder

RUN apk add git make

ARG SERVICE
ARG VERSION_TAG

WORKDIR /src
RUN git clone --depth 1 --branch "${VERSION_TAG}" \
  "https://github.com/lightninglabs/${SERVICE}.git" .

RUN make install

FROM alpine
RUN addgroup -g 913 -S nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

ARG SERVICE
RUN install -o satoshi -g nakamoto -d "/home/satoshi/.${SERVICE}" \
  && install -o satoshi -g nakamoto -d "/home/satoshi/.${SERVICE}/mainnet"

COPY --from=builder /go/bin/* /bin/
USER satoshi:nakamoto