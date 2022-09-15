ARG lnd_version_tag=v0.15.1-beta
FROM lightninglabs/lnd:${lnd_version_tag}

RUN addgroup -g 918 satoshi \
  && adduser -S -D -G satoshi -g lnd lnd \
  && apk add tini su-exec

COPY lnd.conf /etc/lnd.conf
COPY entrypoint.sh /usr/bin/run

ENTRYPOINT ["tini", "--", "run"]
CMD ["lnd"]
