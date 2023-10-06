#! /usr/bin/env bash
set -euxo nounset -o pipefail

if (( ! UID )) &&
   (( ! ${TEAMHACK_DOCKER:-0} )) ; then
echo de-escalate privileges 2>&1
exit 1
fi

if (( ! $# )) ; then
cat 2>&1 << EOF
usage: $0 [airodump-ng.cap]...
EOF
exit 1
fi

exec 0<&-               # close stdin
#exec 2>&1               # redirect stderr to stdout
#renice -n -20 "$$"      # max prio

aircrack-ng                   \
  -w /dev/null                \
  "$@"                      < \
  /dev/null                2> \
  /dev/null                   |
grep                          \
  -e '[1-9][0-9]* handshake'  \
  -e 'with PMKID'

