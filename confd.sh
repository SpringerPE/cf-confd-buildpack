#!/usr/bin/env bash
set -euo pipefail
set -x

# See bin/finalize to check predefined vars
ROOT="/home/vcap"
export CONFD_ROOT=$CONFD_ROOT
export APP_ROOT="${ROOT}/app"
export CONFD_DIR="${CONFD_DIR:-$APP_ROOT/confd}"
export PATH=${PATH}:${CONFD_ROOT}
export CONFD_OPTS=${CONFD_OPTS:-"-onetime -backend env"}

###

# exec process in bg or fg
launch() {
    local background="${1}"
    shift
    (
        echo "Launching pid=$$: '$@'"
        {
            exec $@  2>&1;
        }
    ) &
    pid=$!
    sleep 30
    if ! ps -p ${pid} >/dev/null 2>&1; then
        echo
        echo "Error launching '$@'."
        rvalue=1
    else
        if [[ -z "${background}" ]] && [[ "${background}" == "bg" ]]
        then
            wait ${pid} 2>/dev/null
            rvalue=$?
            echo "Finish pid=${pid}: ${rvalue}"
        else
            rvalue=0
            echo "Background pid=${pid}: 0"
        fi
    fi
    return ${rvalue}
}


run_confd_init() {
    launch fg confd -confdir "${CONFD_DIR}" ${CONFD_OPTS} $@
}

# run
[ -d "${CONFD_DIR}" ] && run_confd_init $@
