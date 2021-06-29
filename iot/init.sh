#!/usr/bin/env bash

set -o pipefail
set -o nounset

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _target_dir="${1:-"$_script_dir"}/iot"
readonly _mqtt_user="${2:-"user"}"
readonly _mqtt_password="${3:-"password"}"
readonly _enable_ssl="${4:-false}"
readonly _certs_dir="${5:-"/etc/ssl/certs"}"

setup_mosquitto_conf_file() {
    local -r __config_file="${1}"

    # backup old config file
    mv "${__config_file}" "${__config_file}.$(date +%s)" 2> /dev/null

    # create config file
    if test "${_enable_ssl}" = true; then
        cat <<EOF >"${__config_file}"
allow_anonymous false
password_file /etc/mosquitto/passwd

listener 1883

listener 8883
certfile /etc/mosquitto/certs/server.crt
cafile /etc/mosquitto/certs/ca.crt
keyfile /etc/mosquitto/certs/server.key

listener 9001
protocol websockets
certfile /etc/mosquitto/certs/server.crt
cafile /etc/mosquitto/certs/ca.crt
keyfile /etc/mosquitto/certs/server.key

EOF
    else
        cat <<EOF >"${__config_file}"
allow_anonymous false
password_file /etc/mosquitto/passwd

listener 1883

EOF
    fi

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

    return $?
}

setup_config_file() {
    local -r __config_file="${1}"

    # backup old config file
    mv "${__config_file}" "${__config_file}.$(date +%s)" 2> /dev/null
    
    # create config file
    cat <<EOF >"${__config_file}"
TARGET_DIR=${_target_dir}
CERTS_DIR=${_certs_dir}

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