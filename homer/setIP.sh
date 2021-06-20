
#!/usr/bin/env bash

set -o pipefail
set -o nounset

readonly _script_dir="$(cd "$(dirname "${0}")" && pwd)"
readonly _ip_address="${1:-"$(ip route get 1.2.3.4 | awk '{print $7}' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}')"}"

overwrite_config_file() {
    local -r __config_file="${1}"
    local __r=1
    
    local __content="$(awk '{gsub(/127.0.0.1/,"'"${_ip_address}"'")}1' "${__config_file}")"
    echo "${__content}" >"${__config_file}" && __r=0

    return "${__r}"
}

main() {
    overwrite_config_file "${_script_dir}/assets/config.yml"
    return $?
}

main "$@"