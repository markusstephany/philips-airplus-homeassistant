#!/usr/bin/env bash

REMOTE_USER="root"
REMOTE_IP=""

scp -r ./custom_components/philips_airplus_multi "${REMOTE_USER}@${REMOTE_IP}:/root/config/custom_components/"

if [[ "${1:-}" == "--restart" ]]; then
  ssh "${REMOTE_USER}@${REMOTE_IP}" 'ha core restart'
fi

echo "Sync complete."