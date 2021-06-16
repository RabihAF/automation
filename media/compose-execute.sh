
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly _dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _compose_command="${1:-"up -d"}"
readonly _vpn_enabled="${VPN_ENABLED:-false}"

main() {

    local __transmission_file="transmission"

    if test "${_vpn_enabled}" = true; then
        __transmission_file="transmission-openvpn"
    fi

    docker-compose --env-file "${_dir}/.env" \
        --file "${_dir}/docker-compose.media.yml" \
        --file "${_dir}/docker-compose.media.sonarr.yml" \
        --file "${_dir}/docker-compose.media.radarr.yml" \
        --file "${_dir}/docker-compose.media.${__transmission_file}.yml" \
        --file "${_dir}/docker-compose.media.bazarr.yml" \
        --file "${_dir}/docker-compose.media.jackett.yml" \
        --file "${_dir}/docker-compose.media.overseerr.yml" \
        --file "${_dir}/docker-compose.media.plex.yml" \
        --file "${_dir}/docker-compose.media.synclounge.yml" \
        ${_compose_command}
    
    return $?
}

main "$@"