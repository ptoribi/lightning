#!/bin/bash

function log_name () {
    [ -n "$SUDO_USER" ] && echo $SUDO_USER
    [ -z "$SUDO_USER" ] && id -un
}

echo "functions --> logname:  $(logname)"
echo "functions --> log_name: $(log_name)"
echo "functions --> whoami:   $(whoami)"
echo "functions --> id -un:   $(id -un)"
