
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly _dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _remove_data="${1:-false}"

main() {

    docker-compose --env-file "${_dir}/config/.env.media" \
        --file "${_dir}/docker-compose.media.yml" \
        --file "${_dir}/docker-compose.media.sonarr.yml" \
        down


    # optional remove data created by media project
    if test "${_remove_data}" = true; then
        rm -rf "${_dir}/secrets" \
         "${_dir}/config" \
         "${_dir}/downloads"
    fi

    return $?
}

main "$@"