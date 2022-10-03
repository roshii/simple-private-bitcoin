FROM alpine
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi
  
RUN apk add tor \
  && chgrp -R nakamoto /var/lib/tor

USER satoshi
ENTRYPOINT ["tor"]
