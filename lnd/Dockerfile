# Prepare final image
ARG version_tag=v0.15.1-beta
FROM lightninglabs/lnd:${version_tag}

RUN addgroup -g 918 satoshi \
  && adduser -S -D -G satoshi -g lnd lnd \
  && apk add tini su-exec

COPY lnd.conf /etc/lnd.conf
COPY entrypoint.sh /usr/bin/run

HEALTHCHECK --start-period=120s --interval=60s --timeout=10s \
  CMD run lncli getinfo

ENTRYPOINT ["tini", "--", "run"]
CMD ["lnd"]
