#!/bin/ash
set -e

chown -R satoshi:nakamoto /home/satoshi 
exec su-exec satoshi:nakamoto "$@"