
#!/usr/bin/env bash

set -o pipefail
set -o nounset

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _target_dir="${1:-"$_script_dir"}/iot"
readonly _mqtt_user="${2:-"user"}"
readonly _mqtt_password="${3:-"password"}"

setup_mosquitto_conf_file() {
    local -r __config_file="${1}"

    # backup old config file
    mv "${__config_file}" "${__config_file}.$(date +%s)" 2> /dev/null

    # create config file
    cat <<EOF >"${__config_file}"
listener 1883
allow_anonymous false
password_file /etc/mosquitto/passwd

EOF

    return $?
}

setup_mosquitto_password_file() {
    local -r __password_file="${1}"

    # backup old password file
    mv "${__password_file}" "${__password_file}.$(date +%s)" 2> /dev/null

    # create password file
    docker run --rm --entrypoint /bin/sh eclipse-mosquitto \
    -c "touch passwd && \
     printf '$_mqtt_password\n$_mqtt_password\n' | mosquitto_passwd -c passwd '$_mqtt_user' > /dev/null && \
     cat passwd" > ${__password_file};

EOF

    return $?
}

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
    setup_mosquitto_conf_file "${_target_dir}/config/mosquitto/mosquitto.conf"
    setup_mosquitto_password_file "${_target_dir}/config/mosquitto/passwd"
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