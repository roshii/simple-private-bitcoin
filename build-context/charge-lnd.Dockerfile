FROM python:alpine AS builder
RUN apk add git

WORKDIR /src

ARG VERSION_TAG=v0.2.12
RUN git clone --depth 1 --branch ${VERSION_TAG} \
  https://github.com/accumulator/charge-lnd.git .

RUN pip wheel --no-cache --no-deps -w /whl .

FROM python:alpine AS final
RUN addgroup -g 913 nakamoto \
  && adduser -g satoshi -G nakamoto -S -D -u 913 satoshi

COPY --from=builder /whl /whl
RUN apk add libstdc++ \
  && rm -rf /var/cache/apk/* \
  && pip install --no-cache /whl/*

WORKDIR /usr/scheduler
COPY ./scheduler/ ./

ENTRYPOINT [ "./start.sh" ]
CMD [ "charge-lnd" ]