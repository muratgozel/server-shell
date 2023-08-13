#!/usr/bin/env sh

. "${PWD}/base/colored_print.sh"

_err() {
    __red "[$(date -u)] $1"
    printf "\n" >&2

    exit 1
}

_info() {
    __blue "[$(date -u)] $1"
    printf "\n" >&2
}

_success() {
    __green "[$(date -u)] $1"
    printf "\n" >&2
}

_exists() {
    cmd="$1"

    if [ -z "$cmd" ]; then
        __red "Usage: _exists cmd" >&2 && printf "\n" >&2
        return 1
    fi

    if eval type type >/dev/null 2>&1; then
        eval type "$cmd" >/dev/null 2>&1
    elif command >/dev/null 2>&1; then
        command -v "$cmd" >/dev/null 2>&1
    else
        which "$cmd" >/dev/null 2>&1
    fi

    ret="$?"

    return $ret
}

is_subdomain() {
  echo "$1" | grep -q '.*\..*\..*'
}

is_nginx_config_valid() {
  nginx -t 2>/dev/null > /dev/null
}
