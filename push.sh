#!/bin/bash

if [ $# == 0 ]; then
   services=(tor bitcoin lnd joinmarket)
else
   services=("$@")
fi

for service in "${services[@]}"
do
   docker-compose build "$service"
   docker push "r0shii/${service}:dev"
done
