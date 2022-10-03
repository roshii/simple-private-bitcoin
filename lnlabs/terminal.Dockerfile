# Build lightning-terminal static files
FROM node:alpine AS static
ARG VERSION=v0.8.0-alpha

RUN apk add git

WORKDIR /src
RUN git clone --depth 1 --branch ${VERSION} \
  https://github.com/lightninglabs/lightning-terminal.git .

WORKDIR /src/app
RUN yarn && yarn build


# Build lightning-terminal binaries
FROM golang:alpine AS builder
COPY --from=static /src /src

RUN apk add git make gcc musl-dev

WORKDIR /src
RUN make go-install-cli && make go-install


# Final image
FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi \
  && apk add tini su-exec

COPY --from=builder /go/bin/* /bin/

ARG SERVICE="lit"
ARG GROUP="statoshi"
ENV LNLABS_SERVICE="$SERVICE"
ENV CONFIG_FILE="${SERVICE}.conf"

COPY "$CONFIG_FILE" /etc/
COPY entrypoint.sh /usr/bin/run

ENTRYPOINT ["tini", "--", "run"]
CMD ["litd"]
