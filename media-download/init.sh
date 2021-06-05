
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly _dir="$(cd "$(dirname "${0}")" && pwd)"

setup_config_file() {
    local -r __config_file="${1}"
    local -r __user_id=$(id -u)
    local -r __group_id=$(id -g)

    cat <<EOF >"${__config_file}"
USER_ID=${__user_id}
GROUP_ID=${__group_id}
EOF

    return $?
}

main() {
    # setup directories
    mkdir -p "${_dir}/secrets" \
         "${_dir}/config/sonarr" \
         "${_dir}/media/tvseries" \
         "${_dir}/downloads/sonarr"

    touch "${_dir}/secrets/password"

    # setup env file
    setup_config_file "${_dir}/config/.env.media"
    echo ".env.media content:"
    cat "${_dir}/config/.env.media"

    echo "docker-compose content:"
    docker-compose --env-file "${_dir}/config/.env.media" \
        --file "${_dir}/docker-compose.media.yml" \
        --file "${_dir}/docker-compose.media.sonarr.yml" \
        config 

    # execute docker-compose
    docker-compose --env-file "${_dir}/config/.env.media" \
        --file "${_dir}/docker-compose.media.yml" \
        --file "${_dir}/docker-compose.media.sonarr.yml" \
        up -d

    return $?
}

main "$@"