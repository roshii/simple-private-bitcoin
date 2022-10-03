FROM golang:alpine AS builder
ARG version=latest

RUN go install github.com/roshii/lndconnect@${version}

FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi \
  && apk add tini su-exec

COPY --from=builder /go/bin/lndconnect /bin/

USER satoshi
CMD ["lndconnect", "-c", "-o"]
