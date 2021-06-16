
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly _dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _compose_command="${1:-"up -d"}"

main() {

    docker-compose --env-file "${_dir}/.env" \
        --file "${_dir}/docker-compose.music.yml" \
        --file "${_dir}/docker-compose.music.deemix.yml" \
        --file "${_dir}/docker-compose.music.mstream.yml" \
        ${_compose_command}

    return $?
}

main "$@"