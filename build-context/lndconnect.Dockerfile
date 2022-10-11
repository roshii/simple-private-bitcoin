FROM golang:alpine AS builder
ARG VERSION=latest

RUN go install github.com/roshii/lndconnect@${VERSION}

FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

COPY --from=builder /go/bin/lndconnect /bin/

USER satoshi:nakamoto
CMD ["lndconnect", "-c", "-o"]
