#!/bin/ash
set -ex

user="jm"
datadir="/srv"
scriptdir="/opt/jm"

# Copy default config if none is set
file_name="joinmarket.cfg"
target="${datadir}/${file_name}"

if ! [ -f "$target" ]; then
  cp "/etc/${file_name}" "$datadir"
fi

chown -R "$user" "$datadir"

# Add datadir flag for Joinmarket scripts
cmd="$1"
found=$(find "$scriptdir" -name "$cmd" -type f -print)

# if [ "$cmd" == "yg-privacyenhanced.py" ] ; then
#   shift
#   exec su-exec "$user" python "$cmd" "--datadir=${datadir}" "$@" -p $(cat /run/secrets/yg-wallet-pwd)
# elif [ -n "$found" ] ; then
#   shift
#   exec su-exec "$user" python "$cmd" "--datadir=${datadir}" "$@"
# else
#   exec su-exec "$user" "$@"
# fi

if [ -n "$found" ] ; then
  shift
  CMD="exec su-exec ${user} python ${cmd} --datadir=${datadir} $@"
  if [ "$cmd" == "yg-privacyenhanced.py" ] ; then
    $CMD --wallet-password-stdin dev
  else
    $CMD
  fi
else
  exec su-exec "$user" "$@"
fi
