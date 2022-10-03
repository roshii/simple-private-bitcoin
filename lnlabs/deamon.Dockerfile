FROM golang:alpine AS builder

RUN apk add git make

ARG SERVICE
ARG VERSION_TAG

WORKDIR /src
RUN git clone --depth 1 --branch "${VERSION_TAG}" \
  "https://github.com/lightninglabs/${SERVICE}.git" .

RUN make install

FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi \
  && apk add tini su-exec

COPY --from=builder /go/bin/* /bin/

ARG SERVICE
ARG GROUP="statoshi"
ENV LNLABS_SERVICE="$SERVICE"
ENV CONFIG_FILE="${SERVICE}d.conf"

COPY "$CONFIG_FILE" /etc/
COPY entrypoint.sh /usr/bin/run

ENTRYPOINT ["tini", "--", "run"]
