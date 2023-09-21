#!/usr/bin/env sh

. "${PWD}/base/base.sh"

# validate dependencies
if ! _exists nginx; then _err "nginx not found."; fi
if ! _exists /root/acme.sh; then _err "acme.sh not found."; fi
if ! _exists psl; then _err "psl not found."; fi

# validate env vars
if [ -z "${SS_APP_HOSTNAME}" ]; then _err "missing env var: SS_APP_HOSTNAME"; fi
if [ -z "${SS_SSL_ROOT}" ]; then _err "missing env var: SS_SSL_ROOT"; fi
if [ -z "${SS_SSL_DNS_PROVIDER}" ]; then _err "missing env var: SS_SSL_DNS_PROVIDER"; fi

# validate dns provider env vars
if [ "${SS_SSL_DNS_PROVIDER}" = "gandi" ]; then
    if [ -z "${GANDI_LIVEDNS_KEY}" ]; then _err "missing env var: GANDI_LIVEDNS_KEY for SS_SSL_DNS_PROVIDER=gandi"; fi
elif [ "${SS_SSL_DNS_PROVIDER}" = "cloudflare" ]; then
    if [ -z "${CF_Key}" ]; then _err "missing env var: CF_Key for SS_SSL_DNS_PROVIDER=cloudflare"; fi
    if [ -z "${CF_Email}" ]; then _err "missing env var: CF_Email for SS_SSL_DNS_PROVIDER=cloudflare"; fi
else
    _err "missing or invalid dns provider."
fi


_info "installing ssl certs for ${SS_APP_HOSTNAME}..."


# prepare cmd args for acme.sh
acme_arg_dns=""
if [ "${SS_SSL_DNS_PROVIDER}" = "gandi" ]; then
    if [ -z "${GANDI_LIVEDNS_KEY}" ]; then _err "missing env var: GANDI_LIVEDNS_KEY for SS_SSL_DNS_PROVIDER=gandi"; fi
    acme_arg_dns="--dns dns_gandi_livedns"
elif [ "${SS_SSL_DNS_PROVIDER}" = "cloudflare" ]; then
    if [ -z "${CF_Key}" ]; then _err "missing env var: CF_Key for SS_SSL_DNS_PROVIDER=cloudflare"; fi
    if [ -z "${CF_Email}" ]; then _err "missing env var: CF_Email for SS_SSL_DNS_PROVIDER=cloudflare"; fi
    acme_arg_dns="--dns dns_cf"
else
    _err "missing or invalid dns provider."
fi

acme_arg_hostnames="-d ${SS_APP_HOSTNAME}"
if ! is_subdomain "${SS_APP_HOSTNAME}"; then
  acme_arg_hostnames="${acme_arg_hostnames} -d www.${SS_APP_HOSTNAME}"
fi

# obtain ssl certs
/root/.acme.sh/acme.sh --issue "$acme_arg_hostnames" "$acme_arg_dns"

# create a directory to keep ssl certs permanently
mkdir -p "${SS_SSL_ROOT}${SS_APP_HOSTNAME}"

ssl_cert=${SS_SSL_ROOT}${SS_APP_HOSTNAME}/fullchain.pem
ssl_cert_key=${SS_SSL_ROOT}${SS_APP_HOSTNAME}/key.pem

# copy cert files to the directory and configure cert auto-renewal
/root/.acme.sh/acme.sh --install-cert -d "${SS_APP_HOSTNAME}" \
    --key-file "$ssl_cert_key" \
    --fullchain-file "$ssl_cert" \
    --reloadcmd "service nginx force-reload"


_success "ssl certs are installed successfully for ${SS_APP_HOSTNAME}"
