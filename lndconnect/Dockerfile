FROM golang:alpine AS builder
ARG version=latest

RUN go install github.com/roshii/lndconnect@${version}

FROM alpine
COPY --from=builder /go/bin/lndconnect /bin/

ARG user=lndconnect
ARG group=statoshi

RUN addgroup -g 918 "$group" \
  && adduser -S -D -G "$group" -g "$user" "$user"

USER "${user}:${group}"
CMD ["lndconnect", "-c", "-o"]
