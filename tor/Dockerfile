ARG image_tag=3.16
FROM alpine:${image_tag}
RUN addgroup -g 918 satoshi \
  && adduser -S -D -G satoshi -g tor tor \
  && apk add tor \
  && chgrp -R satoshi /var/lib/tor
COPY torrc /etc/tor/torrc
USER tor:satoshi
ENTRYPOINT ["tor"]
