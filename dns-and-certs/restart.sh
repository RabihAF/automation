#!/usr/bin/env bash

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"

echo "$(date) - Restart script has been triggered" >> ${_script_dir}/restart.log;
docker container restart mqtt;