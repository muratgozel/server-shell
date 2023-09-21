#!/usr/bin/env sh

. "${PWD}/base/base.sh"

# test subdomain checks
host1=asd.com
host2=www.asd.com
host3=qwe.asd.com
if is_subdomain "${host1}"; then
    _err "${host1} expected to not to be a subdomain"
    exit 1
fi
if ! is_subdomain "${host2}"; then
    _err "${host2} expected to be a subdomain"
    exit 1
fi
if ! is_subdomain "${host3}"; then
    _err "${host3} expected to be a subdomain"
    exit 1
fi

host4=abc.com.tr
host5=www.abc.com.tr
host6=def.abc.com.tr
if is_subdomain "${host4}"; then
    _err "${host4} expected to not to be a subdomain"
    exit 1
fi
if ! is_subdomain "${host5}"; then
    _err "${host5} expected to be a subdomain"
    exit 1
fi
if ! is_subdomain "${host6}"; then
    _err "${host6} expected to be a subdomain"
    exit 1
fi

_success "All tests passed successfully."
exit 0