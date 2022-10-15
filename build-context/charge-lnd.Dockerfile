FROM python:alpine AS builder
RUN apk add \
  build-base \
  git

WORKDIR /srv

ARG VERSION_TAG=v0.2.12
RUN git clone --depth 1 --branch ${VERSION_TAG} \
  https://github.com/accumulator/charge-lnd.git .

# RUN pip wheel --no-cache --no-deps -w /srv \
#   -r requirements.txt

# FROM python:alpine
# RUN addgroup -g 913 nakamoto \
#   && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

# COPY --from=builder /srv /tmp/pip
# RUN pip install --no-cache /tmp/pip/*

# USER satoshi:nakamoto

# COPY --from=builder /src/scripts /opt/jm
# WORKDIR /opt/jm