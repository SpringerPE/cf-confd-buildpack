#!/usr/bin/env bash
set -euo pipefail
set -x

# See bin/finalize to check predefined vars
ROOT="/home/vcap"
export APP_ROOT="${ROOT}/app"
export CONFD_ROOT=$CONFD_ROOT
export PATH=${PATH}:${CONFD_ROOT}

# Settings
export CONFD_MODE="${CONFD_MODE:-onetime}"
export CONFD_OPTS=${CONFD_OPTS:-"-backend env"}
export CONFD_DIR="${CONFD_DIR:-$APP_ROOT/confd}"

###

# exec process in bg or fg
launch() {
    local mode="${1}"
    shift

    local pid
    local rvalue
    (
        echo "Launching (${mode}) pid=$$: $@"
        {
            exec $@  2>&1;
        }
    ) &
    pid=$!
    if [[ "${mode}" == "onetime" ]]
    then
        wait ${pid} 2>/dev/null
        rvalue=$?
        echo "Finish pid=${pid}: ${rvalue}"
    else
        rvalue=0
        echo "Running background pid=${pid}"
    fi
    return ${rvalue}
}


run_confd_init() {
    if [[ "${MODE}" == "onetime" ]]
    then
        launch "${MODE}" confd -onetime -confdir "${CONFD_DIR}" ${CONFD_OPTS} $@
    else
        launch "${MODE}" confd -watch -confdir "${CONFD_DIR}" ${CONFD_OPTS} $@
    fi
}

# run
[ -d "${CONFD_DIR}" ] && run_confd_init $@
