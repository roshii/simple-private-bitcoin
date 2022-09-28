FROM golang:alpine AS builder
ARG SERVICE="loop"
ARG VERSION_TAG="v0.20.1-beta"

RUN apk add git make 

WORKDIR /src
RUN git clone --depth 1 --branch "${VERSION_TAG}" \
  "https://github.com/lightninglabs/${SERVICE}.git" .

RUN make install

FROM alpine
COPY --from=builder /go/bin/* /bin/

ARG SERVICE="loop"
ARG GROUP="statoshi"

RUN addgroup -g 918 "$GROUP" \
  && adduser -S -D -G "$GROUP" -g "$SERVICE" "$SERVICE" \
  && chown -R "$SERVICE" "/home/${SERVICE}" \
  && apk add tini su-exec

COPY "${SERVICE}d.conf" /etc/
COPY entrypoint.sh /usr/bin/run

ENTRYPOINT ["tini", "--", "run"]
CMD ["loopd"]
