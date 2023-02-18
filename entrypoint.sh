#!/bin/bash

set -eu

PUREFTPD_PASSWD_FILE=${PUREFTPD_PASSWD_FILE:-/etc/pureftpd.passwd}
PUREFTPD_PDB_FILE=${PUREFTPD_PDB_FILE:-/etc/pureftpd.pdb}

if [[ -f "$PUREFTPD_PASSWD_FILE" ]]; then
  echo "pure-pw mkdb \"$PUREFTPD_PDB_FILE\" -f \"$PUREFTPD_PASSWD_FILE\"" >> /dev/stderr
  pure-pw mkdb "$PUREFTPD_PDB_FILE" -f "$PUREFTPD_PASSWD_FILE"
fi

exec "$@"
