FROM alpine AS final
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi
  
RUN apk add tor \
  && rm -rf /var/cache/apk/* \
  && chgrp -R nakamoto /var/lib/tor

USER satoshi:nakamoto
CMD ["tor"]
