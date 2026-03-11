#!/bin/bash
if [ -f /tmp/start_dualscope_vertical ]; then
    rm /tmp/start_dualscope_vertical

    sudo /usr/local/bin/dualscope/dualscope_vertical.sh

    return-to-gamemode
fi
