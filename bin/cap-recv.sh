#! /usr/bin/env bash
set -euxo nounset -o pipefail

if (( ! UID )) &&
   (( ! ${DOCKER_TEAMHACK:-0} )) ; then
echo de-escalate privileges 1>&2
exit 1
fi

if (( $# )) ; then
cat 1>&2 << EOF
usage: $0
(does not accept arguments)
EOF
exit 1
fi

exec 0<&-               # close stdin
#exec 2>&1               # redirect stderr to stdout
#renice -n -20 "$$"      # max prio

cap="$(mktemp --suffix=.cap --tmpdir=caps/upload)"
trap "rm -v $cap" 0
cat > "$cap"

lst="$(mktemp --suffix=.lst --tmpdir=/tmp/teamhack)"
trap "rm -v $cap $lst" 0

aircrack-ng.lst.sh "$cap" |
tee "$lst"                |
awk -v "C=$cap"           \
$'{
  cmd = "[ -e psks/"$2".psk ] || ln -v "C" caps/bssid/"$2".cap"
  while ((cmd | getline output) > 0)
    print output;
  close(cmd)
}'

# TODO
#cat "$lst"

