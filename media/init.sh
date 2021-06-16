
#!/usr/bin/env bash

set -o pipefail
set -o nounset

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _target_dir="${1:-"$_script_dir"}/media"
readonly _plex_token="${2:-""}"
readonly _transmission_username="${3:-""}"
readonly _transmission_password="${4:-""}"
readonly _vpn_enabled="${5:-false}"
readonly _openvpn_provider_provided="${6:-"NORDVPN"}"
readonly _openvpn_config_provided="${7:-"france"}"
readonly _openvpn_username_provided="${8:-""}"
readonly _openvpn_password_provided="${9:-""}"
readonly _openvpn_local_network_provided="${10:-"192.168.0.0/16"}"

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
PLEX_TOKEN=${_plex_token}
TRANSMISSION_USERNAME=${_transmission_username}
TRANSMISSION_PASSWORD=${_transmission_password}
VPN_ENABLED=${_vpn_enabled}
OPENVPN_PROVIDER_PROVIDED=${_openvpn_provider_provided}
OPENVPN_CONFIG_PROVIDED=${_openvpn_config_provided}
OPENVPN_USERNAME_PROVIDED=${_openvpn_username_provided}
OPENVPN_PASSWORD_PROVIDED=${_openvpn_password_provided}
OPENVPN_LOCAL_NETWORK_PROVIDED=${_openvpn_local_network_provided}

EOF

    return $?
}

main() {
    # setup directories
    mkdir -p "${_target_dir}/secrets" \
         "${_target_dir}/config/sonarr" \
         "${_target_dir}/config/radarr" \
         "${_target_dir}/config/transmission" \
         "${_target_dir}/config/bazarr" \
         "${_target_dir}/config/jackett" \
         "${_target_dir}/config/overseerr" \
         "${_target_dir}/config/plex" \
         "${_target_dir}/downloads/watch" \
         "${_target_dir}/downloads/data" \
         "${_target_dir}/tvseries" \
         "${_target_dir}/movies" 

    sudo chmod +x ${_script_dir}/compose-execute.sh

    # setup files
    touch "${_target_dir}/secrets/password"
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