#!/usr/bin/env bash

# Guard clause to prevent multiple inclusions of this file
[[ "${_MAYBE_SH_INCLUDED:-}" == "true" ]] && return
declare -r _MAYBE_SH_INCLUDED="true"
log_debug "Sourcing maybe.sh"

# Encapsulate a successful value
Just() {
    local value="$1"
    echo "Just:$value"
}

# Represent absence of value
Nothing() {
    echo "Nothing"
}

# Apply a function to the value if it's Just
bind() {
    local maybe="$1"
    local func="$2"

    if [[ "$maybe" == Just:* ]]; then
        local value="${maybe#Just:}"
        $func "$value"
    else
        Nothing
    fi
}

# Utility: Check if value is 'Just'
is_just() {
    [[ "$1" == Just:* ]]
}

# Utility: Check if value is 'Nothing'
is_nothing() {
    [[ "$1" == "Nothing" ]]
}

# End of maybe.sh
