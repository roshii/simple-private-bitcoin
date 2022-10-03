ARG VERSION_TAG=v0.15.1-beta
FROM lightninglabs/lnd:${VERSION_TAG}

RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

HEALTHCHECK --start-period=120s --interval=60s --timeout=10s \
  CMD run lncli getinfo

USER satoshi:nakamoto
CMD ["lnd"]
