ARG lnd_version_tag=v0.15.1-beta
FROM golang:alpine AS builder

ARG lndconnect_version_tag=latest
RUN go install github.com/roshii/lndconnect@${lndconnect_version_tag}

FROM lightninglabs/lnd:${lnd_version_tag}

RUN addgroup -g 918 satoshi \
  && adduser -S -D -G satoshi -g lnd lnd \
  && apk add tini su-exec

COPY --from=builder /go/bin/lndconnect /bin/

COPY lnd.conf /etc/lnd.conf
COPY entrypoint.sh /usr/bin/run

ENTRYPOINT ["tini", "--", "run"]
CMD ["lnd"]
