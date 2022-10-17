#!/bin/ash

crontab -u satoshi "/usr/scheduler/crontabs/${@:-hello}"
crond -f