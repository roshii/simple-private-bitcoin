ARG image_tag=3.15
FROM alpine:${image_tag}
RUN apk add tor
COPY torrc /etc/tor/torrc
USER tor
ENTRYPOINT ["tor"]
