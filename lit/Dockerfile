# Build lightning-terminal static files
FROM node:alpine AS static
ARG version=v0.8.0-alpha

RUN apk add git

WORKDIR /src
RUN git clone --depth 1 --branch ${version} \
  https://github.com/lightninglabs/lightning-terminal.git .

WORKDIR /src/app
RUN yarn
RUN yarn build


# Build lightning-terminal binaries
FROM golang:alpine AS builder
COPY --from=static /src /src

RUN apk add git make gcc musl-dev

WORKDIR /src
RUN make go-install-cli
RUN make go-install


# Final image
FROM alpine
COPY --from=builder /go/bin/* /bin/

ARG user=lit
ARG group=statoshi

RUN addgroup -g 918 "$group" \
  && adduser -S -D -G "$group" -g "$user" "$user"

USER "${user}:${group}"
CMD ["litd", "--httpslisten=lit:8443", "--uipassword=thisisatest"]