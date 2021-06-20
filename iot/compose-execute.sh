
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly _dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _compose_command="${1:-"up -d"}"

main() {

    docker-compose --env-file "${_dir}/.env" \
        --file "${_dir}/docker-compose.iot.yml" \
        --file "${_dir}/docker-compose.iot.nodered.yml" \
        --file "${_dir}/docker-compose.iot.homeassistant.yml" \
        --file "${_dir}/docker-compose.iot.mqtt.yml" \
        ${_compose_command}
    
    return $?
}

main "$@"