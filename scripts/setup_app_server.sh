#!/usr/bin/env sh

set -eu

. "${PWD}/base/base.sh"

# validate env vars
if [ -z "${SS_APP_ROOT}" ]; then _err "missing env var: SS_APP_ROOT"; fi
if [ -z "${SS_APP_HOSTNAME}" ]; then _err "missing env var: SS_APP_HOSTNAME"; fi
if [ -z "${SS_APP_PORT}" ]; then _err "missing env var: SS_APP_PORT"; fi

export SS_NGINX_CONF_DIR=/etc/nginx/conf.d/

if [ ! -d "${SS_APP_ROOT}${SS_APP_HOSTNAME}/www" ]; then
  mkdir -p "${SS_APP_ROOT}${SS_APP_HOSTNAME}/www"
  if [ -n "${SS_APP_ROOT_GROUP_OWNER}" ]; then
    chgrp "${SS_APP_ROOT_GROUP_OWNER}" "${SS_APP_ROOT}${SS_APP_HOSTNAME}/www"
    chmod g+w "${SS_APP_ROOT}${SS_APP_HOSTNAME}/www"
  fi
fi

export SS_NGINX_SSL_CERTIFICATE_PATH=${SS_SSL_ROOT}${SS_APP_HOSTNAME}/fullchain.pem
export SS_NGINX_SSL_CERTIFICATE_KEY_PATH=${SS_SSL_ROOT}${SS_APP_HOSTNAME}/key.pem

nginx_server_names="${SS_APP_HOSTNAME}"
if ! is_subdomain "${SS_APP_HOSTNAME}"; then
  nginx_server_names="${nginx_server_names} www.${SS_APP_HOSTNAME}"
fi
export SS_NGINX_SERVER_NAMES="$nginx_server_names"
export SS_NGINX_PROXY_PASS="http://localhost:${SS_APP_PORT}"
export SS_NGINX_WEBROOT="${SS_APP_ROOT}${SS_APP_HOSTNAME}/www"

envsubst '${SS_NGINX_SERVER_NAMES},${SS_NGINX_SSL_CERTIFICATE_PATH},${SS_NGINX_SSL_CERTIFICATE_KEY_PATH},${SS_NGINX_PROXY_PASS},${SS_NGINX_WEBROOT}' < "${HOME}/${SS_APP_KIND}_nginx_template.conf" > "${SS_NGINX_CONF_DIR}${SS_APP_HOSTNAME}.conf"

if ! is_nginx_config_valid; then
    _err "failed to validate nginx config."
fi

service nginx force-reload

_success "nginx conf generated successfully and app server is ready (${SS_APP_HOSTNAME})"
