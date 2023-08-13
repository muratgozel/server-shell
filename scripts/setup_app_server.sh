#!/usr/bin/env sh

set -eu

. "${PWD}/base/base.sh"

# validate dependencies
if ! _exists aws; then _err "aws not found."; fi

# validate env vars
if [ -z "${SS_APP_ROOT}" ]; then _err "missing env var: SS_APP_ROOT"; fi
if [ -z "${SS_APP_HOSTNAME}" ]; then _err "missing env var: SS_APP_HOSTNAME"; fi
if [ -z "${SS_APP_PORT}" ]; then _err "missing env var: SS_APP_PORT"; fi
if [ -z "${SS_S3_NGINX_CONF_PATH}" ]; then _err "missing env var: SS_S3_NGINX_CONF_PATH"; fi
if [ -z "${SS_S3_PROFILE}" ]; then _err "missing env var: SS_S3_PROFILE"; fi

export SS_NGINX_CONF_DIR=/etc/nginx/conf.d/

if [ ! -d "${SS_APP_ROOT}${SS_APP_HOSTNAME}/www" ]; then
  mkdir -p "${SS_APP_ROOT}${SS_APP_HOSTNAME}/www"
fi

export SS_NGINX_SSL_CERTIFICATE_PATH=${SSLROOT}${APP_DOMAIN}/fullchain.pem
export SS_NGINX_SSL_CERTIFICATE_KEY_PATH=${SSLROOT}${APP_DOMAIN}/key.pem

nginx_server_names="${SS_SSL_HOSTNAME}"
if ! is_subdomain "${SS_SSL_HOSTNAME}"; then
  nginx_server_names="${nginx_server_names} www.${SS_SSL_HOSTNAME}"
fi
export SS_NGINX_SERVER_NAMES=$nginx_server_names
export SS_NGINX_PROXY_PASS="http://localhost:${SS_APP_PORT}"

aws s3 cp "${SS_S3_NGINX_CONF_PATH}" "${SS_NGINX_CONF_DIR}${SS_APP_HOSTNAME}.conf.template" --profile "${SS_S3_PROFILE}"

envsubst < "${SS_NGINX_CONF_DIR}${SS_APP_HOSTNAME}.conf.template" > "${SS_NGINX_CONF_DIR}${SS_APP_HOSTNAME}.conf"

if ! is_nginx_config_valid; then
    _err "failed to validate nginx config."
fi

service nginx force-reload