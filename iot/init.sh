
#!/usr/bin/env bash

set -o pipefail
set -o nounset

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _target_dir="${1:-"$_script_dir"}/iot"

setup_config_file() {
    local -r __config_file="${1}"

    # backup old config file
    mv "${__config_file}" "${__config_file}.$(date +%s)" 2> /dev/null
    
    # create config file
    cat <<EOF >"${__config_file}"
TARGET_DIR=${_target_dir}

EOF

    return $?
}

main() {
    # setup directories
    mkdir -p "${_target_dir}/data/nodered" \
         "${_target_dir}/config/homeassistant" \
         "${_target_dir}/config/mosquitto" \
         "${_target_dir}/data/mosquitto" \
         "${_target_dir}/log/mosquitto" 

    sudo chmod +x ${_script_dir}/compose-execute.sh

    # setup files
    touch "${_target_dir}/config/mosquitto/mosquitto.conf"
    setup_config_file "${_script_dir}/.env"

    echo ".env content"
    cat "${_script_dir}/.env"

    echo "docker-compose content"
    ${_script_dir}/compose-execute.sh config

    echo "docker-compose execute"
    ${_script_dir}/compose-execute.sh pull

    return $?
}

main "$@"