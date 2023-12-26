#!/usr/bin/env sh

. "${PWD}/base/base.sh"

if [ "$OP_TEST" != "abc123" ]; then
    _err "The value of OP_TEST doesn't match."
    exit 1
fi

if [ "$OP_APP_TEST" != "def456" ]; then
    _err "The value of OP_APP_TEST doesn't match."
    exit 1
fi

_success "All tests passed successfully."
exit 0