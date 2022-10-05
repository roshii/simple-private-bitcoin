# Build lightning-terminal static files
FROM node:alpine AS static
RUN apk add git

WORKDIR /src
ARG VERSION=v0.8.0-alpha
RUN git clone --depth 1 --branch ${VERSION} \
  https://github.com/lightninglabs/lightning-terminal.git .

WORKDIR /src/app
RUN yarn && yarn build


# Build lightning-terminal binaries
FROM golang:alpine AS builder
RUN apk add git make gcc musl-dev

WORKDIR /src
COPY --from=static /src /src
RUN make go-install-cli && make go-install

# Final image
FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

COPY --from=builder /go/bin/* /bin/
CMD ["litd"]
