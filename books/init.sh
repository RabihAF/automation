
#!/usr/bin/env bash

set -o pipefail
set -o nounset

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _target_dir="${1:-"$_script_dir"}/books"

setup_config_file() {
    local -r __config_file="${1}"
    local -r __user_id=$(id -u)
    local -r __group_id=$(id -g)

    # backup old config file
    mv "${__config_file}" "${__config_file}.$(date +%s)" 2> /dev/null
    
    # create config file
    cat <<EOF >"${__config_file}"
USER_ID=${__user_id}
GROUP_ID=${__group_id}
TARGET_DIR=${_target_dir}

EOF

    return $?
}

main() {
    # setup directories
    mkdir -p "${_target_dir}/secrets" \
         "${_target_dir}/config/lazylibrarian" \
         "${_target_dir}/config/calibre-web" \
         "${_target_dir}/downloads" 

    # setup files
    touch "${_target_dir}/secrets/password"
    setup_config_file "${_script_dir}/.env"

    sudo chmod +x ${_script_dir}/compose-execute.sh

    echo ".env content"
    cat "${_script_dir}/.env"

    echo "docker-compose content"
    ${_script_dir}/compose-execute.sh config

    echo "docker-compose execute"
    ${_script_dir}/compose-execute.sh pull

    return $?
}

main "$@"