FROM golang:alpine AS builder

RUN apk add git make 
WORKDIR /src


ARG SERVICES="loop pool faraday"
ARG VERSION_TAG

RUN set -- $SERVICES \
  && while [ -n "$1" ]; do \
    echo $1; \
  # git clone --depth 1 --branch "https://github.com/lightninglabs/${1}.git" . \
  # && make install \
    shift; \
  done

FROM alpine
COPY --from=builder /go/bin/* /bin/

ARG SERVICE
ARG GROUP="statoshi"
ENV LNLABS_SERVICE="$SERVICE"

RUN addgroup -g 918 "$GROUP" \
  && adduser -S -D -G "$GROUP" -g "$SERVICE" "$SERVICE" \
  && chown -R "$SERVICE" "/home/${SERVICE}" \
  && apk add tini su-exec

COPY "${SERVICE}d.conf" /etc/
COPY entrypoint.sh /usr/bin/run

ENTRYPOINT ["tini", "--", "run"]
CMD ["${LNLABS_SERVICE}d"]
